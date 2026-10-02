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
    cachyos_kernel,
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

    def test_hrd_updates_source_before_go_dependencies(self):
        self.assert_package_update(
            "hrd",
            "hugoh/hrd",
            "goModules",
            '  vendorHash = "sha256-old-dependencies";\n',
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

    def test_cachyos_kernel_checks_the_locked_revision(self):
        revision = "abc123"
        self.write(
            "flake.lock",
            json.dumps(
                {"nodes": {"nix-cachyos-kernel": {"locked": {"rev": revision}}}}
            ),
        )
        context = types.SimpleNamespace(
            root=self.root,
            output=lambda *command: (
                "/nix/store/0123456789abcdefghijklmnopqrstuv-linux-7.1.3"
            ),
            url_status=lambda url: 200,
        )
        cachyos_kernel.check(context)


if __name__ == "__main__":
    unittest.main()
