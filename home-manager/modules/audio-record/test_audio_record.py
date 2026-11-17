import io
import json
import math
import os
import signal
import struct
import subprocess
import sys
import tempfile
import time
import unittest
import wave
from contextlib import redirect_stderr
from pathlib import Path

from audio_record import Request, parse_request

SCRIPT = Path(__file__).with_name("audio_record.py")
RATE = 48000

FAKE_TRANSCRIBE = """#!/bin/sh
[ "$FAKE_TRANSCRIBE" = fail ] && exit 1
[ "$2" = -o ] && printf 'SPEAKER_00 [00:00]: hi\\n' > "$3"
"""

FAKE_PW_RECORD = f"""#!{sys.executable}
import os, signal, sys, time, wave
if os.environ.get("FAKE_PW") == "die":
    sys.exit(1)
system = "stream.capture.sink" in " ".join(sys.argv)
os.link(os.environ["SYSTEM_WAV" if system else "MIC_WAV"], sys.argv[-1])
signal.signal(signal.SIGINT, lambda *_: sys.exit(0))
while True:
    time.sleep(0.1)
"""


def write_wav(path: Path, segments: list[tuple[float, bool]]) -> None:
    frames = bytearray()
    for duration, tone in segments:
        for i in range(int(duration * RATE)):
            sample = int(8000 * math.sin(2 * math.pi * 440 * i / RATE)) if tone else 0
            frames += struct.pack("<hh", sample, sample)
    with wave.open(str(path), "wb") as out:
        out.setnchannels(2)
        out.setsampwidth(2)
        out.setframerate(RATE)
        out.writeframes(bytes(frames))


class ParseRequestTest(unittest.TestCase):
    def test_free_text_splits_duration_from_label(self):
        cases = {
            "standup 1h": (3600, "standup"),
            "1h standup": (3600, "standup"),
            "standup 1 hour": (3600, "standup"),
            "office hours 1h 30m": (5400, "office-hours"),
            "2 mins sync": (120, "sync"),
            "1 on 1": (None, "1-on-1"),
            "1on1 Review": (None, "1on1-review"),
            "": (None, ""),
        }
        for text, (limit, slug) in cases.items():
            with self.subTest(text):
                request = parse_request(text.split())
                self.assertEqual((request.limit, request.slug), (limit, slug))

    def test_flags(self):
        self.assertEqual(
            parse_request(["-d", "1h", "review", "5m"]),
            Request(3600, "1h", "review-5m"),
        )
        self.assertEqual(
            parse_request(["-l", "Q3 5m review", "1h", "30m"]),
            Request(5400, "1h 30m", "q3-5m-review"),
        )
        self.assertEqual(
            parse_request(["standup", "-t", "1h"]),
            Request(3600, "1h", "standup", transcribe=True),
        )

    def test_rejects_mistyped_durations(self):
        for argv in (
            ["1.5h", "standup"],
            ["standup", "90mn"],
            ["1.5", "hours"],
            ["-d", "0s"],
            ["-l", "standup", "tomorrow"],
            ["--bogus"],
        ):
            with self.subTest(argv), redirect_stderr(io.StringIO()):
                with self.assertRaises(SystemExit) as raised:
                    parse_request(argv)
                self.assertEqual(raised.exception.code, 2)


class RecordingTest(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.root = Path(tmp.name)
        bin_dir = self.root / "bin"
        bin_dir.mkdir()
        (bin_dir / "pw-record").write_text(FAKE_PW_RECORD)
        (bin_dir / "notify-send").write_text("#!/bin/sh\n")
        (bin_dir / "parakeet-transcribe").write_text(FAKE_TRANSCRIBE)
        for tool in bin_dir.iterdir():
            tool.chmod(0o755)
        mic, system = self.root / "mic-src.wav", self.root / "system-src.wav"
        write_wav(mic, [(1.0, False), (1.0, True), (1.0, False)])
        write_wav(system, [(3.0, False)])
        self.out = self.root / "out"
        self.env = {
            **os.environ,
            "PATH": f"{bin_dir}:{os.environ['PATH']}",
            "MIC_WAV": str(mic),
            "SYSTEM_WAV": str(system),
            "REC_OUT_DIR": str(self.out),
            "REC_SILENCE_DURATION": "0.5",
        }

    def start(self, *args, **env):
        proc = subprocess.Popen(
            [sys.executable, str(SCRIPT), *args],
            env={**self.env, **env},
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            start_new_session=True,
        )
        self.addCleanup(self.kill_group, proc)
        return proc

    @staticmethod
    def kill_group(proc):
        try:
            os.killpg(proc.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        proc.wait()

    def saved_duration(self, name: str) -> float:
        probe = subprocess.run(
            ["ffprobe", "-v", "error", "-show_entries", "format=duration"]
            + ["-of", "json", str(self.out / name)],
            capture_output=True,
            text=True,
            check=True,
        )
        return float(json.loads(probe.stdout)["format"]["duration"])

    def test_time_limit_stops_and_trims_edge_silence(self):
        proc = self.start("1s", "standup")
        output, _ = proc.communicate(timeout=30)
        self.assertEqual(proc.returncode, 0, output)
        [saved] = os.listdir(self.out)
        self.assertTrue(saved.endswith("-standup.opus"), saved)
        self.assertAlmostEqual(self.saved_duration(saved), 1.0, delta=0.15)

    def test_transcribe_writes_transcript_next_to_recording(self):
        proc = self.start("1s", "-t", "sync")
        output, _ = proc.communicate(timeout=30)
        self.assertEqual(proc.returncode, 0, output)
        [opus] = self.out.glob("*-sync.opus")
        self.assertEqual(
            opus.with_suffix(".txt").read_text(), "SPEAKER_00 [00:00]: hi\n"
        )

    def test_failed_transcription_keeps_recording(self):
        proc = self.start("1s", "-t", FAKE_TRANSCRIBE="fail")
        output, _ = proc.communicate(timeout=30)
        self.assertEqual(proc.returncode, 1)
        self.assertIn("recording kept", output)
        self.assertEqual([p.suffix for p in self.out.iterdir()], [".opus"])

    def test_sigterm_saves_unlimited_recording(self):
        proc = self.start()
        time.sleep(1)
        proc.send_signal(signal.SIGTERM)
        output, _ = proc.communicate(timeout=30)
        self.assertEqual(proc.returncode, 0, output)
        self.assertEqual(len(os.listdir(self.out)), 1)

    def test_dead_recorders_end_limited_run_at_once(self):
        started = time.monotonic()
        proc = self.start("1h", FAKE_PW="die")
        output, _ = proc.communicate(timeout=10)
        self.assertLess(time.monotonic() - started, 5)
        self.assertEqual(proc.returncode, 1)
        self.assertIn("No audio captured", output)


if __name__ == "__main__":
    unittest.main()
