import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


class ScreenshotTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.home = Path(self.tmp.name) / "home with spaces"
        self.directory = self.home / "Pictures" / "Screenshots"
        self.directory.mkdir(parents=True)
        self.bin = Path(self.tmp.name) / "bin"
        self.bin.mkdir()
        satty = self.bin / "satty"
        satty.write_text(
            f"#!{os.sys.executable}\n"
            "import json, sys\nprint(json.dumps(sys.argv[1:]))\n"
        )
        satty.chmod(0o755)
        notify = self.bin / "notify-send"
        notify.write_text("#!/bin/sh\nprintf '%s\\n' \"$*\" >&2\n")
        notify.chmod(0o755)

    def run_script(self, *args):
        return subprocess.run(
            ["bash", str(Path(__file__).with_name("annotate-screenshot.sh")), *args],
            env={
                **os.environ,
                "HOME": str(self.home),
                "PATH": f"{self.bin}:{os.environ['PATH']}",
            },
            cwd=self.bin,
            capture_output=True,
            text=True,
        )

    def test_latest_original_ignores_exports_and_directories(self):
        for name, time in (
            ("Older.png", 100),
            ("Screenshot with spaces.png", 200),
            ("Screenshot with spaces-annotated.png", 300),
            ("Older-edited-2026-10-05.png", 400),
        ):
            file = self.directory / name
            file.write_bytes(b"original")
            os.utime(file, (time, time))
        (self.directory / "Not a screenshot.png").mkdir()

        result = self.run_script()

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            json.loads(result.stdout),
            [
                "--filename",
                str(self.directory / "Screenshot with spaces.png"),
                "--output-filename",
                str(self.directory / "Screenshot with spaces-annotated.png"),
            ],
        )
        self.assertEqual(
            (self.directory / "Screenshot with spaces.png").read_bytes(), b"original"
        )

    def test_selected_file_and_reopened_annotation(self):
        (self.directory / "Newer screenshot.png").write_bytes(b"newer")
        for name, output in (
            ("Older screenshot.png", "Older screenshot-annotated.png"),
            ("Older screenshot-annotated.png", "Older screenshot-annotated.png"),
            ("100% done.png", "100%% done-annotated.png"),
        ):
            with self.subTest(name=name):
                file = self.bin / name
                file.write_bytes(b"selected")

                result = self.run_script(name)

                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(
                    json.loads(result.stdout),
                    [
                        "--filename",
                        str(file),
                        "--output-filename",
                        str(self.bin / output),
                    ],
                )
                self.assertEqual(file.read_bytes(), b"selected")

    def test_invalid_selection_does_not_open_an_unrelated_screenshot(self):
        (self.directory / "Valid.png").write_bytes(b"original")
        for args in (
            (str(self.directory),),
            ("missing.png",),
            ("one.png", "two.png"),
        ):
            with self.subTest(args=args):
                result = self.run_script(*args)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")
                self.assertTrue(result.stderr)

    def test_no_originals_reports_an_error(self):
        (self.directory / "Only-annotated.png").write_bytes(b"annotation")
        for directory_exists in (True, False):
            with self.subTest(directory_exists=directory_exists):
                if not directory_exists:
                    (self.directory / "Only-annotated.png").unlink()
                    self.directory.rmdir()
                result = self.run_script()
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")
                self.assertIn("No original screenshots", result.stderr)


if __name__ == "__main__":
    unittest.main()
