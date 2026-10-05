import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

from test_accounts import account_script


@unittest.skipUnless(
    os.getenv("AMP_TEST_SSH_GENERATIONS"),
    "root-owned fixtures require nix build .#checks.x86_64-linux.amp-accounts",
)
class SSHTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.base = Path(temporary.name)
        self.env = {**os.environ, "HOME": str(self.base)}
        for kind in ("CONFIG", "DATA", "CACHE", "STATE"):
            self.env[f"XDG_{kind}_HOME"] = str(self.base / kind.lower())
        self.config = self.base / "ssh_config"
        self.passwd = self.base / "passwd"
        self.passwd.write_text(
            f"amp-test:x:{os.getuid()}:{os.getgid()}:Test:{self.base}:/bin/sh\n"
        )
        ssh = self.base / ".ssh"
        (ssh / "config.d").mkdir(parents=True)
        (ssh / "config").write_text("Include config.d/*\n")
        (ssh / "config.d/hosts").write_text(
            "Host github-alias\n  HostName github.com\n  User fixture-user\n"
            "Host *\n  ServerAliveCountMax 7\n"
        )
        self.launcher = self.base / "launcher.sh"
        self.generations = os.environ["AMP_TEST_SSH_GENERATIONS"].split(":")
        self.assertEqual(len(self.generations), 2)

    def run_command(self, arguments, mounts=()):
        return subprocess.run(
            [
                "bwrap",
                "--bind",
                "/",
                "/",
                "--dev-bind",
                "/dev",
                "/dev",
                "--ro-bind",
                str(self.passwd),
                "/etc/passwd",
                "--ro-bind",
                str(self.config),
                str(Path("/etc/ssh/ssh_config").resolve()),
                *mounts,
                "--",
                *arguments,
            ],
            input="piped input",
            text=True,
            capture_output=True,
            env=self.env,
            cwd=self.base,
        )

    def test_active_generations_and_proxy_combinations(self):
        probe = self.base / "probe.py"
        self.launcher.write_text(account_script("personal", probe))
        for tag, generation in zip(
            ("a", "b", "a"), (*self.generations, self.generations[0]), strict=True
        ):
            fragments = [
                Path(generation) / "etc/ssh/ssh_config.d/30-libvirt-ssh-proxy.conf",
                Path(generation) / "lib/systemd/ssh_config.d/20-systemd-ssh-proxy.conf",
            ]
            for libvirt, systemd in (
                (False, False),
                (True, False),
                (False, True),
                (True, True),
            ):
                with self.subTest(generation=tag, libvirt=libvirt, systemd=systemd):
                    included = [
                        path
                        for path, enabled in zip(
                            fragments, (libvirt, systemd), strict=True
                        )
                        if enabled
                    ]
                    self.config.write_text(
                        (f"Include {fragments[0]}\n" if libvirt else "")
                        + "Host *\n"
                        + (f"Include {fragments[1]}\n" if systemd else "")
                        + "GlobalKnownHostsFile /test/system-known-hosts\n"
                        + "ServerAliveInterval 43\n"
                    )
                    baseline = self.run_command(["ssh", "-G", "github-alias"])
                    if included:
                        self.assertEqual(baseline.returncode, 255)
                        self.assertIn("Bad owner or permissions", baseline.stderr)
                    else:
                        self.assertEqual(baseline.returncode, 0, baseline.stderr)
                    for path in included:
                        self.assertNotIn(path.stat().st_uid, (0, os.getuid()))
                    probe.write_text(
                        f"#!{os.sys.executable}\n"
                        "import errno, json, os, pathlib, subprocess, sys\n"
                        "result = subprocess.run(['ssh', '-G', sys.argv[1]], check=True, text=True, capture_output=True)\n"
                        "states = []\n"
                        f"for name in {list(map(str, included))!r}:\n"
                        "    path = pathlib.Path(name)\n"
                        "    try:\n"
                        "        with path.open('wb'): pass\n"
                        "    except OSError as error:\n"
                        "        assert error.errno == errno.EROFS, error\n"
                        "    else:\n"
                        "        raise AssertionError('SSH fragment is writable')\n"
                        "    states.append([path.stat().st_uid, path.stat().st_mode & 0o777, path.read_text()])\n"
                        "fds = []\n"
                        "for fd in pathlib.Path('/proc/self/fd').iterdir():\n"
                        "    if int(fd.name) > 2 and fd.exists(): fds.append(fd.name)\n"
                        "print(json.dumps([result.stdout, states, fds, sys.stdin.read()]))\n"
                    )
                    probe.chmod(0o700)
                    for host, proxy in (
                        ("github-alias", None),
                        (
                            "qemu:system/test",
                            f"/amp-fixture-{tag}/libvirt-ssh-proxy %h %p"
                            if libvirt
                            else None,
                        ),
                        (
                            "vsock/3",
                            f"/amp-fixture-{tag}/systemd-ssh-proxy %h %p"
                            if systemd
                            else None,
                        ),
                        (
                            ".host",
                            f"/amp-fixture-{tag}/systemd-ssh-proxy %h %p"
                            if systemd
                            else None,
                        ),
                    ):
                        result = self.run_command(["sh", str(self.launcher), host])
                        self.assertEqual(result.returncode, 0, result.stderr)
                        expanded, states, fds, stdin = json.loads(result.stdout)
                        settings = dict(
                            line.split(" ", 1) for line in expanded.splitlines()
                        )
                        self.assertEqual(settings.get("proxycommand"), proxy)
                        self.assertEqual(
                            settings["proxyusefdpass"], "yes" if proxy else "no"
                        )
                        self.assertEqual(
                            settings["globalknownhostsfile"], "/test/system-known-hosts"
                        )
                        self.assertEqual(settings["serveraliveinterval"], "43")
                        self.assertEqual(settings["serveralivecountmax"], "7")
                        if host == "github-alias":
                            self.assertEqual(settings["hostname"], "github.com")
                            self.assertEqual(settings["user"], "fixture-user")
                        self.assertEqual(
                            states,
                            [
                                [os.getuid(), 0o600, path.read_text()]
                                for path in included
                            ],
                        )
                        self.assertEqual(fds, [])
                        self.assertEqual(stdin, "piped input")

    def test_unsupported_includes_fail_before_launch(self):
        path = (
            Path(self.generations[0]) / "etc/ssh/ssh_config.d/30-libvirt-ssh-proxy.conf"
        )
        self.launcher.write_text(account_script("personal", os.sys.executable))
        for directive in (
            f'Include "{path}"',
            f"Include {path} {path}",
            f"Include {path.parent}/*30-libvirt-ssh-proxy.conf",
        ):
            with self.subTest(directive=directive):
                self.config.write_text(directive + "\n")
                result = self.run_command(
                    ["sh", str(self.launcher), "-c", "print('executed')"]
                )
                self.assertEqual(result.returncode, 1)
                self.assertIn("unsupported system SSH Include", result.stderr)
                self.assertEqual(result.stdout, "")

        nested = self.base / "nested"
        nested.write_text("Host *\nInclude /etc/ssh/ssh_config\n")
        self.config.write_text(f"Include {path}\n")
        result = self.run_command(
            ["sh", str(self.launcher), "-c", "print('executed')"],
            mounts=["--ro-bind", str(nested), str(path)],
        )
        self.assertEqual(result.returncode, 1)
        self.assertIn("nested SSH Includes are not supported", result.stderr)
        self.assertEqual(result.stdout, "")


if __name__ == "__main__":
    unittest.main()
