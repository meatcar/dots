"""Transcribe a recording with speaker labels, using parakeet.cpp."""

import argparse
import os
import re
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path

ASR_MODEL = os.environ.get("PARAKEET_ASR_MODEL", "")
DIAR_MODEL = os.environ.get("PARAKEET_DIAR_MODEL", "")

# One `parakeet-cli scene` utterance: "[MM:SS.t - MM:SS.t]  Speaker N: text".
UTTERANCE = re.compile(r"\[(\d+):(\d+(?:\.\d+)?) - [^\]]*\]\s+Speaker (\d+|\?): ?(.*)")


@dataclass
class Turn:
    speaker: int | None
    start: float
    text: str


class Failure(Exception):
    pass


def parse_scene(output: str) -> list[Turn]:
    """Merge consecutive utterances of one speaker into turns."""
    turns: list[Turn] = []
    for line in output.splitlines():
        match = UTTERANCE.fullmatch(line.strip())
        if not match:
            continue
        minutes, secs, speaker, text = match.groups()
        text = text.strip()
        if not text:
            continue
        who = None if speaker == "?" else int(speaker)
        if turns and turns[-1].speaker == who:
            turns[-1].text += f" {text}"
        else:
            turns.append(Turn(who, int(minutes) * 60 + float(secs), text))
    return turns


def timestamp(seconds: float) -> str:
    hours, rest = divmod(int(seconds), 3600)
    minutes, secs = divmod(rest, 60)
    clock = f"{minutes:02d}:{secs:02d}"
    return f"{hours:02d}:{clock}" if hours else clock


def render(turns: list[Turn]) -> str:
    def label(speaker: int | None) -> str:
        return "UNKNOWN" if speaker is None else f"SPEAKER_{speaker:02d}"

    return "".join(
        f"{label(t.speaker)} [{timestamp(t.start)}]: {t.text}\n" for t in turns
    )


def scene(wav: Path, device: str | None) -> subprocess.CompletedProcess:
    env = {**os.environ, "PARAKEET_DEVICE": device} if device else None
    return subprocess.run(
        ["parakeet-cli", "scene", "--model", ASR_MODEL, "--diar", DIAR_MODEL]
        + ["--input", str(wav)],
        env=env,
        capture_output=True,
        text=True,
    )


def last_line(text: str) -> str:
    lines = text.strip().splitlines()
    return lines[-1] if lines else "no output"


def transcribe(audio: Path) -> str:
    with tempfile.TemporaryDirectory(prefix="parakeet-transcribe-") as tmp:
        wav = Path(tmp) / "audio.wav"
        decode = subprocess.run(
            ["ffmpeg", "-nostdin", "-v", "error", "-i", str(audio)]
            + ["-ar", "16000", "-ac", "1", str(wav)],
            capture_output=True,
            text=True,
        )
        if decode.returncode != 0:
            raise Failure(f"cannot decode {audio}: {last_line(decode.stderr)}")

        result = scene(wav, None)
        if result.returncode != 0 and "PARAKEET_DEVICE" not in os.environ:
            print(
                f"parakeet-transcribe: GPU run failed ({last_line(result.stderr)});"
                " retrying on CPU, which is slower",
                file=sys.stderr,
            )
            result = scene(wav, "cpu")
        if result.returncode != 0:
            raise Failure(f"parakeet-cli failed: {last_line(result.stderr)}")

    turns = parse_scene(result.stdout)
    if not turns:
        raise Failure(f"no speech found in {audio}")
    return render(turns)


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(
        prog="parakeet-transcribe",
        description=(
            "Transcribe a recording with speaker labels, one turn per line:"
            " 'SPEAKER_00 [mm:ss]: text'. Set PARAKEET_DEVICE (cpu, Vulkan0, ...)"
            " to pick a device; otherwise the first GPU is used, with a CPU retry."
        ),
    )
    parser.add_argument("audio", type=Path, help="any format ffmpeg can read")
    parser.add_argument("-o", "--output", type=Path, help="write here, not stdout")
    args = parser.parse_args(argv)
    if not args.audio.is_file():
        parser.error(f"no such file: {args.audio}")

    try:
        text = transcribe(args.audio)
    except Failure as error:
        print(f"parakeet-transcribe: {error}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        return 130

    if args.output:
        # NOTE: rename so readers never see a partial transcript.
        partial = args.output.with_name(f".{args.output.name}.partial")
        partial.write_text(text)
        partial.replace(args.output)
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
