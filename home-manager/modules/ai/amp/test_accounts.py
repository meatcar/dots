import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


class AccountsTest(unittest.TestCase):
    def test_account_mounts(self):
        for symlinks in (False, True):
            with self.subTest(symlinks=symlinks), tempfile.TemporaryDirectory() as tmp:
                base = Path(tmp)
                home = base / "home with spaces"
                home.mkdir()
                env = {
                    **os.environ,
                    "HOME": str(home),
                    "AMP_API_KEY": "test-only",
                    "AMP_SETTINGS_FILE": "/wrong/settings.json",
                    "AMP_LOG_FILE": "/wrong/log",
                }
                paths = {"home": home / ".amp"}
                for kind in ("CONFIG", "DATA", "CACHE", "STATE"):
                    parent = home / kind.lower()
                    env[f"XDG_{kind}_HOME"] = str(parent)
                    paths[kind.lower()] = parent / "amp"
                for kind, path in paths.items():
                    path.parent.mkdir(parents=True, exist_ok=True)
                    if symlinks:
                        target = base / f"persist-{kind}"
                        target.mkdir()
                        path.symlink_to(target)
                    else:
                        path.mkdir()
                    (path / "marker").write_text("host")

                probe = base / "probe.py"
                probe.write_text(
                    "import json, os, pathlib, sys\n"
                    "with open('/dev/null', 'w') as device: device.write('test')\n"
                    f"paths = {list(map(str, paths.values()))!r}\n"
                    "before = []\n"
                    "for path in paths:\n"
                    "    marker = pathlib.Path(path) / 'marker'\n"
                    "    before.append(marker.read_text() if marker.exists() else None)\n"
                    "    temp = marker.with_suffix('.tmp')\n"
                    "    temp.write_text(sys.argv[1])\n"
                    "    temp.replace(marker)\n"
                    "print(json.dumps([before, sys.argv[1:], sys.stdin.read(), "
                    "os.getcwd(), [os.getenv(k) for k in "
                    "['AMP_API_KEY', 'AMP_SETTINGS_FILE', 'AMP_LOG_FILE']]]))\n"
                    "sys.exit(int(sys.argv[2]))\n"
                )
                launcher = base / "launcher.sh"
                for account, expected in (
                    ("work", None),
                    ("personal", None),
                    ("work", "work"),
                ):
                    launcher.write_text(
                        Path(__file__)
                        .with_name("amp-account.sh")
                        .read_text()
                        .replace("@amp@", f"{os.sys.executable} {probe}")
                        .replace("@account@", account)
                    )
                    result = subprocess.run(
                        ["sh", str(launcher), account, "17", "two words", ""],
                        input="piped input",
                        text=True,
                        capture_output=True,
                        env=env,
                        cwd=home,
                    )
                    self.assertEqual(result.returncode, 17, result.stderr)
                    self.assertEqual(
                        json.loads(result.stdout),
                        [
                            [expected] * 5,
                            [account, "17", "two words", ""],
                            "piped input",
                            str(home),
                            [None] * 3,
                        ],
                    )
                for path in paths.values():
                    self.assertEqual((path / "marker").read_text(), "host")
                for account in ("work", "personal"):
                    root = home / "data/amp-accounts" / account
                    self.assertEqual(root.stat().st_mode & 0o777, 0o700)
                    for kind in paths:
                        self.assertEqual((root / kind / "marker").read_text(), account)


if __name__ == "__main__":
    unittest.main()
