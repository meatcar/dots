import base64
import json
import pathlib
import subprocess
import sys
import tempfile
import types
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).parents[1]))

from depslib import cli
from depslib.handlers import (
    amp_completions,
    opensessions,
    paseo,
    swaync_theme,
)
from depslib.core import DependencyError


class HandlerCheckTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.root = pathlib.Path(self.temporary.name)

    def tearDown(self):
        self.temporary.cleanup()

    def write(self, relative, content):
        path = self.root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)
        return path

    def test_amp_completions_requires_a_non_flake_pin(self):
        lock = self.write(
            "flake.lock",
            json.dumps({"nodes": {"amp-completions": {"flake": False}}}),
        )
        amp_completions.check(types.SimpleNamespace(root=self.root))

        lock.write_text(json.dumps({"nodes": {"amp-completions": {"flake": True}}}))
        with self.assertRaisesRegex(DependencyError, "non-flake input"):
            amp_completions.check(types.SimpleNamespace(root=self.root))

    def test_amp_completions_updates_only_its_pin(self):
        self.write(
            "flake.lock",
            json.dumps({"nodes": {"amp-completions": {"flake": False}}}),
        )
        calls = []
        context = types.SimpleNamespace(
            root=self.root, run=lambda *args: calls.append(args)
        )

        amp_completions.update(context)

        self.assertEqual(calls, [("nix", "flake", "update", "amp-completions")])

    def test_opensessions_requires_two_hashes_and_versioned_binary(self):
        self.write(
            "pkgs/opensessions/default.nix",
            '  version = "1.0.0";\n'
            '    hash = "sha256-source";\n'
            '      url = "releases/download/v${version}/opensessions-sidebar";\n'
            '      hash = "sha256-binary";\n',
        )
        opensessions.check(types.SimpleNamespace(root=self.root))

    def test_paseo_requires_an_npm_hash(self):
        self.write(
            "home-manager/modules/paseo/default.nix",
            '      npmDepsHash = "sha256-dependencies";\n',
        )
        paseo.check(types.SimpleNamespace(root=self.root))

    def assert_package_update(self, name, repository, dependency_attribute, dependency):
        source = self.write(
            f"pkgs/{name}/default.nix",
            '  version = "1.2.3";\n' + dependency + "  src = fetchFromGitHub {\n"
            '    tag = "v${finalAttrs.version}";\n'
            '    hash = "sha256-old-source";\n'
            "  };\n",
        )
        calls = []
        attribute = f".#legacyPackages.x86_64-linux.{name}"

        def latest_release(repo):
            self.assertEqual(repo, repository)
            return {"tag_name": "v9.8.7"}

        def run(*command, **kwargs):
            calls.append(command[2])
            self.assertIn('version = "9.8.7";', source.read_text())
            if command[2] == f"{attribute}.src":
                self.assertIn('"sha256-old-dependencies"', source.read_text())
                hash_value = "sha256-new-source"
            else:
                self.assertEqual(command[2], f"{attribute}.{dependency_attribute}")
                self.assertIn('hash = "sha256-new-source";', source.read_text())
                hash_value = "sha256-new-dependencies"
            if kwargs.get("check") is False:
                return subprocess.CompletedProcess(
                    command, 1, "", f"got: {hash_value}\n"
                )
            self.assertIn(f'"{hash_value}"', source.read_text())
            return subprocess.CompletedProcess(command, 0, "", "")

        context = types.SimpleNamespace(
            root=self.root,
            latest_release=latest_release,
            run=run,
            verify=lambda: calls.append("verify"),
        )
        cli.main(["update", name], context)
        self.assertEqual(
            calls,
            [f"{attribute}.src"] * 2
            + [f"{attribute}.{dependency_attribute}"] * 2
            + ["verify"],
        )

    def test_hrd_tracks_fork_branch_and_updates_source_before_go_dependencies(self):
        source = self.write(
            "pkgs/hrd/default.nix",
            '  version = "unstable-2026-09-30";\n'
            '    rev = "1111111111111111111111111111111111111111";\n'
            '    hash = "sha256-old-source";\n'
            '  vendorHash = "sha256-old-dependencies";\n',
        )
        calls = []
        attribute = ".#legacyPackages.x86_64-linux.hrd"

        def github(path):
            self.assertEqual(path, "/repos/meatcar/hrd/commits/fix/tui-root-groups")
            return {
                "sha": "2222222222222222222222222222222222222222",
                "commit": {"committer": {"date": "2026-10-04T21:10:32Z"}},
            }

        def run(*command, **kwargs):
            calls.append(command[2])
            text = source.read_text()
            self.assertIn('version = "unstable-2026-10-04";', text)
            self.assertIn('rev = "2222222222222222222222222222222222222222";', text)
            if command[2] == f"{attribute}.src":
                self.assertIn('vendorHash = "sha256-old-dependencies";', text)
                hash_value = "sha256-new-source"
            else:
                self.assertEqual(command[2], f"{attribute}.goModules")
                self.assertIn('hash = "sha256-new-source";', text)
                hash_value = "sha256-new-dependencies"
            if kwargs.get("check") is False:
                return subprocess.CompletedProcess(
                    command, 1, "", f"got: {hash_value}\n"
                )
            self.assertIn(f'"{hash_value}"', text)
            return subprocess.CompletedProcess(command, 0, "", "")

        context = types.SimpleNamespace(
            root=self.root,
            github=github,
            run=run,
            verify=lambda: calls.append("verify"),
        )
        cli.main(["update", "hrd"], context)
        self.assertEqual(
            calls,
            [f"{attribute}.src"] * 2 + [f"{attribute}.goModules"] * 2 + ["verify"],
        )

    def test_insta360_linux_tracks_main_with_package_json_version(self):
        source = self.write(
            "pkgs/insta360-linux/default.nix",
            '  version = "0.1.0-unstable-2026-03-03";\n'
            "  src = fetchFromGitHub {\n"
            '    rev = "1111111111111111111111111111111111111111";\n'
            '    hash = "sha256-old-source";\n'
            "  };\n"
            "  pnpmDeps = fetchPnpmDeps {\n"
            '    hash = "sha256-old-dependencies";\n'
            "  };\n",
        )
        revision = "2222222222222222222222222222222222222222"
        attribute = ".#legacyPackages.x86_64-linux.insta360-linux"
        responses = {
            "/repos/EdenCoder/insta360-linux/commits/main": {
                "sha": revision,
                "commit": {"committer": {"date": "2026-10-04T21:10:32Z"}},
            },
            f"/repos/EdenCoder/insta360-linux/contents/package.json?ref={revision}": {
                "encoding": "base64",
                "content": base64.b64encode(b'{"version": "0.2.0"}').decode(),
            },
        }

        def run(*command, **kwargs):
            if kwargs.get("check") is False:
                hash_value = {
                    f"{attribute}.src": "sha256-new-source",
                    f"{attribute}.pnpmDeps": "sha256-new-dependencies",
                }[command[2]]
                return subprocess.CompletedProcess(
                    command, 1, "", f"got: {hash_value}\n"
                )
            return subprocess.CompletedProcess(command, 0, "", "")

        context = types.SimpleNamespace(
            root=self.root, github=responses.__getitem__, run=run, verify=lambda: None
        )
        cli.main(["update", "insta360-linux"], context)
        self.assertEqual(
            source.read_text(),
            '  version = "0.2.0-unstable-2026-10-04";\n'
            "  src = fetchFromGitHub {\n"
            f'    rev = "{revision}";\n'
            '    hash = "sha256-new-source";\n'
            "  };\n"
            "  pnpmDeps = fetchPnpmDeps {\n"
            '    hash = "sha256-new-dependencies";\n'
            "  };\n",
        )

    def test_forgemap_distinguishes_pnpm_hash_from_source_hash(self):
        self.assert_package_update(
            "forgemap",
            "TitusKirch/forgemap",
            "pnpmDeps",
            "  pnpmDeps = fetchPnpmDeps {\n"
            '    hash = "sha256-old-dependencies";\n'
            "  };\n",
        )

    def test_figma_console_mcp_distinguishes_npm_hash_from_source_hash(self):
        self.assert_package_update(
            "figma-console-mcp",
            "southleft/figma-console-mcp",
            "npmDeps",
            '  npmDepsHash = "sha256-old-dependencies";\n',
        )

    def test_pipewire_control_center_updates_release_and_source_hash(self):
        source = self.write(
            "pkgs/pipewire-control-center/default.nix",
            '  version = "1.2.3";\n'
            "  src = fetchFromGitHub {\n"
            '    tag = "v${finalAttrs.version}";\n'
            '    hash = "sha256-old-source";\n'
            "  };\n",
        )
        attribute = ".#legacyPackages.x86_64-linux.pipewire-control-center"

        def latest_release(repo):
            self.assertEqual(repo, "knightinfected/PipeWireController")
            return {"tag_name": "v9.8.7"}

        def run(*command, **kwargs):
            self.assertEqual(command[2], f"{attribute}.src")
            if kwargs.get("check") is False:
                return subprocess.CompletedProcess(
                    command, 1, "", "got: sha256-new-source\n"
                )
            return subprocess.CompletedProcess(command, 0, "", "")

        context = types.SimpleNamespace(
            root=self.root, latest_release=latest_release, run=run, verify=lambda: None
        )
        cli.main(["update", "pipewire-control-center"], context)
        self.assertEqual(
            source.read_text(),
            '  version = "9.8.7";\n'
            "  src = fetchFromGitHub {\n"
            '    tag = "v${finalAttrs.version}";\n'
            '    hash = "sha256-new-source";\n'
            "  };\n",
        )

    def test_amp_desktop_takes_its_version_from_the_apt_index(self):
        source = self.write(
            "pkgs/amp-desktop/default.nix",
            '  version = "0.1.1";\n'
            "  src = fetchurl {\n"
            '    url = "https://static.ampcode.com/linux/${finalAttrs.version}/x.deb";\n'
            '    hash = "sha256-old-source";\n'
            "  };\n",
        )
        index = (
            "Package: amp-desktop-beta\n"
            "Version: 0.2.0\n"
            "\n"
            "Package: amp-desktop\n"
            "Architecture: amd64\n"
            "Version: 0.1.2\n"
            "SHA256: 00\n"
        )
        attribute = ".#legacyPackages.x86_64-linux.amp-desktop"

        def run(*command, **kwargs):
            self.assertEqual(command[2], f"{attribute}.src")
            if kwargs.get("check") is False:
                return subprocess.CompletedProcess(
                    command, 1, "", "got: sha256-new-source\n"
                )
            return subprocess.CompletedProcess(command, 0, "", "")

        context = types.SimpleNamespace(
            root=self.root,
            fetch_text=lambda url: index,
            run=run,
            verify=lambda: None,
        )
        cli.main(["update", "amp-desktop"], context)
        self.assertEqual(
            source.read_text(),
            '  version = "0.1.2";\n'
            "  src = fetchurl {\n"
            '    url = "https://static.ampcode.com/linux/${finalAttrs.version}/x.deb";\n'
            '    hash = "sha256-new-source";\n'
            "  };\n",
        )

    def test_forgemap_rejects_missing_source_hash(self):
        self.write(
            "pkgs/forgemap/default.nix",
            '  version = "1.2.3";\n'
            "  src = fetchFromGitHub {\n"
            "    hash = lib.fakeHash;\n"
            "  };\n"
            "  pnpmDeps = fetchPnpmDeps {\n"
            '    hash = "sha256-dependencies";\n'
            "  };\n",
        )
        with self.assertRaisesRegex(DependencyError, "expected one match"):
            cli.discover_handlers()["forgemap"].check(
                types.SimpleNamespace(root=self.root)
            )

    def test_swaync_theme_requires_lock_url_to_match_flake(self):
        url = "https://github.com/catppuccin/swaync/releases/download/v1.0.1/catppuccin-mocha.css"
        self.write("flake.nix", f'url = "{url}";\n')
        self.write(
            "flake.lock",
            json.dumps({"nodes": {swaync_theme.INPUT: {"locked": {"url": url}}}}),
        )
        swaync_theme.check(types.SimpleNamespace(root=self.root))


if __name__ == "__main__":
    unittest.main()
