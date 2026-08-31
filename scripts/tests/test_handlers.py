import json
import pathlib
import sys
import tempfile
import types
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).parents[1]))

from depslib.core import DependencyError
from depslib.handlers import (
    cachyos_kernel,
    cpa_manager_plus,
    opensessions,
    paseo,
    pi_bridge,
    swaync_theme,
)


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

    def test_cpa_manager_plus_requires_versions_and_lock_urls_to_agree(self):
        version = "1.2.3"
        urls = {
            architecture: cpa_manager_plus.release_url(version, architecture)
            for architecture in cpa_manager_plus.INPUTS
        }
        self.write("flake.nix", "\n".join(f'url = "{url}";' for url in urls.values()))
        self.write(
            "home-manager/modules/ai/cli-proxy-api/manager-plus/default.nix",
            f'  version = "{version}";\n',
        )
        self.write(
            "flake.lock",
            json.dumps(
                {
                    "nodes": {
                        input_name: {"locked": {"url": urls[architecture]}}
                        for architecture, input_name in cpa_manager_plus.INPUTS.items()
                    }
                }
            ),
        )

        cpa_manager_plus.check(types.SimpleNamespace(root=self.root))

        self.write("flake.lock", json.dumps({"nodes": {}}))
        with self.assertRaisesRegex(DependencyError, "missing from flake.lock"):
            cpa_manager_plus.check(types.SimpleNamespace(root=self.root))

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

    def test_pi_bridge_requires_source_and_sdk_versions_to_match(self):
        bridge = self.root / "bridge"
        bridge.mkdir()
        (bridge / "registry.json").write_text(
            json.dumps({"plugins": [{"id": "pi-bridge", "version": "0.7.1"}]})
        )
        self.write(
            "home-manager/modules/ai/cli-proxy-api/pi-bridge/default.nix",
            '  bridgeVersion = "0.7.1";\n  cliProxyApiSdkVersion = "7.2.146";\n',
        )

        def output(*command):
            return (
                "7.2.146" if command[-1] == pi_bridge.PACKAGE_ATTRIBUTE else str(bridge)
            )

        pi_bridge.check(types.SimpleNamespace(root=self.root, output=output))

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
