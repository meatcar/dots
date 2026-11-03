"""Record mic and system audio, then save a trimmed, normalized Opus file."""

import argparse
import os
import re
import shutil
import signal
import subprocess
import sys
import tempfile
import time
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path

OUT_DIR = Path(
    os.environ.get("REC_OUT_DIR", Path.home() / "Sync/notes/_inbox/recordings")
)
BITRATE = os.environ.get("REC_BITRATE", "96k")
SILENCE_THRESHOLD = os.environ.get("REC_SILENCE_THRESHOLD", "-40dB")
SILENCE_DURATION = os.environ.get("REC_SILENCE_DURATION", "1.0")
LOUDNESS = os.environ.get("REC_LOUDNESS", "-16")

UNIT_SECONDS = {
    **dict.fromkeys(["h", "hr", "hrs", "hour", "hours"], 3600),
    **dict.fromkeys(["m", "min", "mins", "minute", "minutes"], 60),
    **dict.fromkeys(["s", "sec", "secs", "second", "seconds"], 1),
}
DURATION = re.compile(r"\s*(?:[0-9]+\s*[a-z]+\s*)+")
DURATION_PART = re.compile(r"([0-9]+)\s*([a-z]+)")
NUMBER = re.compile(r"[0-9]+")
DECIMAL = re.compile(r"[0-9]+\.[0-9]+")
DURATION_TYPO = re.compile(r"[0-9][0-9.]*[a-z]+")

MIX = "[0:a][1:a]amix=inputs=2:duration=longest:normalize=0"
# Trimmed only where silence touches the start or end of the recording.
EDGE = 0.1


@dataclass(frozen=True)
class Request:
    limit: int | None
    limit_text: str
    slug: str


class Stop(Exception):
    pass


def parse_duration(text: str) -> int | None:
    """Return total seconds for text such as "1h 30m" or "2 mins", else None."""
    text = text.lower().replace(",", " ")
    if not DURATION.fullmatch(text):
        return None
    total = 0
    for number, unit in DURATION_PART.findall(text):
        if unit not in UNIT_SECONDS:
            return None
        total += int(number) * UNIT_SECONDS[unit]
    return total or None


def split_words(words: list[str]) -> tuple[list[str], list[str]]:
    """Split free text into duration words and label words."""
    duration: list[str] = []
    label: list[str] = []
    i = 0
    while i < len(words):
        word = words[i]
        following = words[i + 1] if i + 1 < len(words) else ""
        if NUMBER.fullmatch(word) and parse_duration(f"{word} {following}"):
            duration.append(f"{word} {following}")
            i += 2
            continue
        if parse_duration(word):
            duration.append(word)
        elif DURATION_TYPO.fullmatch(word.lower()) or (
            DECIMAL.fullmatch(word) and parse_duration(f"1 {following}")
        ):
            raise ValueError(
                f"not a duration: {word!r}. Use whole numbers (1h 30m),"
                " or -l for a label."
            )
        else:
            label.append(word)
        i += 1
    return duration, label


def slugify(words: list[str]) -> str:
    return re.sub(r"[^a-z0-9]+", "-", " ".join(words).lower()).strip("-")


def duration_arg(text: str) -> str:
    if not parse_duration(text):
        raise argparse.ArgumentTypeError(f"invalid duration: {text!r}")
    return text


def parse_request(argv: list[str]) -> Request:
    parser = argparse.ArgumentParser(
        prog="audio-record",
        description="Record mic and system audio until Ctrl-C or a time limit.",
        epilog=(
            "Without flags, words that parse as a duration (1h, '1 hour', '2 mins')"
            " set the time limit and the rest form the label. With -d, all words"
            " are label. With only -l, all words are duration."
        ),
    )
    parser.add_argument(
        "-d", "--duration", type=duration_arg, help="stop after this long, e.g. 1h"
    )
    parser.add_argument("-l", "--label", help="appended to the filename")
    parser.add_argument("words", nargs="*", help="free text: duration and label")
    args = parser.parse_intermixed_args(argv)

    label = [args.label] if args.label is not None else []
    if args.duration:
        duration_words = [args.duration]
        label += args.words
    elif args.label is not None:
        duration_words = args.words
        text = " ".join(duration_words)
        if duration_words and not parse_duration(text):
            parser.error(f"invalid duration: {text!r}")
    else:
        try:
            duration_words, label = split_words(args.words)
        except ValueError as error:
            parser.error(str(error))

    limit_text = " ".join(duration_words)
    return Request(parse_duration(limit_text), limit_text, slugify(label))


def notify(title: str, body: str) -> None:
    try:
        subprocess.run(["notify-send", title, body], check=False)
    except OSError:
        pass


def has_audio(wav: Path) -> bool:
    # A bare WAV header is 44 bytes; anything larger means real samples landed.
    return wav.exists() and wav.stat().st_size > 44


def seconds(hours: str, minutes: str, secs: str) -> float:
    return int(hours) * 3600 + int(minutes) * 60 + float(secs)


def trim_bounds(log: str) -> tuple[float, float | None]:
    """Return start and end of the recording without edge silence."""
    total = max(
        (seconds(*m) for m in re.findall(r"Duration: (\d+):(\d+):([\d.]+)", log)),
        default=None,
    )
    silences: list[list[float | None]] = []
    for kind, value in re.findall(r"silence_(start|end): (-?[\d.]+)", log):
        if kind == "start":
            silences.append([float(value), None])
        elif silences:
            silences[-1][1] = float(value)

    start, end = 0.0, total
    if silences:
        first_start, first_end = silences[0]
        if first_start < EDGE and first_end is not None:
            start = first_end
        last_start, last_end = silences[-1]
        if last_end is None or (total is not None and total - last_end < EDGE):
            end = last_start
    if end is not None and end <= start:
        return 0.0, total
    return start, end


def encode(mic: Path, system: Path, out: Path) -> None:
    inputs = ["-i", str(mic), "-i", str(system)]
    # NOTE: areverse-based trimming buffers the whole stream twice and OOMs on
    # multi-hour recordings; detect bounds in a streaming pass instead.
    silencedetect = f"silencedetect=noise={SILENCE_THRESHOLD}:d={SILENCE_DURATION}"
    detect = subprocess.run(
        ["ffmpeg", "-nostdin", "-hide_banner", "-y", *inputs]
        + ["-filter_complex", f"{MIX},{silencedetect}", "-f", "null", "-"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
        text=True,
        check=True,
    )
    start, end = trim_bounds(detect.stderr)
    trim = f"atrim=start={start}" + (f":end={end}" if end is not None else "")
    filters = [
        MIX,
        trim,
        "asetpts=PTS-STARTPTS",
        f"loudnorm=I={LOUDNESS}:TP=-1.5:LRA=11",
        "aresample=48000",
    ]
    subprocess.run(
        ["ffmpeg", "-nostdin", "-y", "-loglevel", "warning", *inputs]
        + ["-filter_complex", ",".join(filters)]
        + ["-c:a", "libopus", "-b:a", BITRATE, "-application", "audio", str(out)],
        check=True,
    )


def main(argv: list[str]) -> int:
    request = parse_request(argv)

    def stop(_signum, _frame):
        raise Stop

    signal.signal(signal.SIGINT, stop)
    signal.signal(signal.SIGTERM, stop)

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    workdir = Path(tempfile.mkdtemp(prefix="audio-record-"))
    mic, system = workdir / "mic.wav", workdir / "system.wav"
    recorders = [
        # WirePlumber relinks both streams when the default device changes.
        subprocess.Popen(["pw-record", "--target", "auto", str(mic)]),
        subprocess.Popen(
            ["pw-record", "--target", "auto"]
            + ["-P", '{ "stream.capture.sink": "true" }', str(system)]
        ),
    ]

    if request.limit:
        print(f"Recording for {request.limit_text}… Ctrl-C to stop early.")
    else:
        print("Recording… Ctrl-C to stop.")
    print(f"  mic:    {mic}\n  system: {system}")
    if request.slug:
        print(f"  label:  {request.slug}")

    deadline = time.monotonic() + request.limit if request.limit else None
    try:
        while any(r.poll() is None for r in recorders) and (
            deadline is None or time.monotonic() < deadline
        ):
            time.sleep(0.2)
    except Stop:
        pass

    signal.signal(signal.SIGINT, signal.SIG_IGN)
    signal.signal(signal.SIGTERM, signal.SIG_IGN)
    print("Stopping…", flush=True)
    for recorder in recorders:
        # SIGINT lets pw-record flush and finalize the WAV header.
        if recorder.poll() is None:
            recorder.send_signal(signal.SIGINT)
    for recorder in recorders:
        recorder.wait()

    if not (has_audio(mic) or has_audio(system)):
        print("No audio captured; nothing to save.", file=sys.stderr)
        notify("Recording failed", "No audio was captured")
        shutil.rmtree(workdir)
        return 1

    timestamp = datetime.now().strftime("%Y-%m-%dT%H-%M-%S")
    suffix = f"-{request.slug}" if request.slug else ""
    out = OUT_DIR / f"recording-{timestamp}{suffix}.opus"
    try:
        encode(mic, system, out)
    except subprocess.CalledProcessError:
        print(f"Encoding failed; raw audio kept in {workdir}", file=sys.stderr)
        notify("Recording failed", f"Raw audio kept in {workdir}")
        return 1

    shutil.rmtree(workdir)
    print(f"Saved: {out}")
    notify("Recording saved", str(out))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
