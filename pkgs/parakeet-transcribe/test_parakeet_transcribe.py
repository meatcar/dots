import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("parakeet_transcribe.py")

SCENE = """\
loading model...
[00:00.0 - 00:00.4]  Speaker 1: Happy?
[00:01.1 - 00:07.2]  Speaker 0: Yes, we can
[00:07.9 - 00:08.4]  Speaker 0: refer to notes.
[09:59.6 - 10:01.0]  Speaker 1: Okay.
[59:59.0 - 60:02.0]  Speaker 1: Still here.
[60:05.5 - 60:06.0]  Speaker ?: Hmm.
[61:00.0 - 61:00.1]  Speaker 0:
"""

FAKE_PARAKEET_CLI = f"""#!{sys.executable}
import os, sys, wave
args = sys.argv[1:]
wav = wave.open(args[args.index("--input") + 1])
if os.environ.get("PARAKEET_DEVICE") != os.environ.get("FAKE_WORKS_ON"):
    sys.exit("ggml_vulkan: device lost")
print(open(os.environ["FAKE_SCENE"]).read() if wav.getnframes() else "")
"""


class TranscribeTest(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.root = Path(tmp.name)
        bin_dir = self.root / "bin"
        bin_dir.mkdir()
        cli = bin_dir / "parakeet-cli"
        cli.write_text(FAKE_PARAKEET_CLI)
        cli.chmod(0o755)
        scene = self.root / "scene.txt"
        scene.write_text(SCENE)
        self.audio = self.root / "meeting.opus"
        subprocess.run(
            ["ffmpeg", "-v", "error", "-f", "lavfi", "-i", "sine=d=1"]
            + ["-c:a", "libopus", str(self.audio)],
            check=True,
        )
        env = {k: v for k, v in os.environ.items() if k != "PARAKEET_DEVICE"}
        self.env = {
            **env,
            "PATH": f"{bin_dir}:{os.environ['PATH']}",
            "FAKE_SCENE": str(scene),
        }

    def run_cli(self, *args, **env):
        return subprocess.run(
            [sys.executable, str(SCRIPT), *map(str, args)],
            env={**self.env, **env},
            capture_output=True,
            text=True,
        )

    def test_merges_turns_and_labels_speakers(self):
        out = self.root / "meeting.txt"
        result = self.run_cli(self.audio, "-o", out)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, "")
        self.assertEqual(
            out.read_text(),
            "SPEAKER_01 [00:00]: Happy?\n"
            "SPEAKER_00 [00:01]: Yes, we can refer to notes.\n"
            "SPEAKER_01 [09:59]: Okay. Still here.\n"
            "UNKNOWN [01:00:05]: Hmm.\n",
        )
        self.assertNotIn(".meeting.txt.partial", os.listdir(self.root))

    def test_retries_on_cpu_when_gpu_fails(self):
        result = self.run_cli(self.audio, FAKE_WORKS_ON="cpu")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("retrying on CPU", result.stderr)
        self.assertTrue(result.stdout.startswith("SPEAKER_01 [00:00]: Happy?\n"))

    def test_chosen_device_failure_is_not_retried(self):
        result = self.run_cli(
            self.audio, PARAKEET_DEVICE="Vulkan1", FAKE_WORKS_ON="cpu"
        )
        self.assertEqual(result.returncode, 1)
        self.assertIn("device lost", result.stderr)
        self.assertNotIn("retrying", result.stderr)

    def test_silence_fails_without_output(self):
        silent = self.root / "silent.wav"
        subprocess.run(
            ["ffmpeg", "-v", "error", "-f", "lavfi", "-i", "anullsrc", "-t", "0"]
            + [str(silent)],
            check=True,
        )
        out = self.root / "silent.txt"
        result = self.run_cli(silent, "-o", out)
        self.assertEqual(result.returncode, 1)
        self.assertIn("no speech found", result.stderr)
        self.assertFalse(out.exists())

    def test_rejects_unreadable_input(self):
        junk = self.root / "junk.opus"
        junk.write_text("not audio")
        for path, message in (
            (junk, "cannot decode"),
            (self.root / "nope.opus", "no such file"),
        ):
            with self.subTest(path.name):
                result = self.run_cli(path)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn(message, result.stderr)


if __name__ == "__main__":
    unittest.main()
