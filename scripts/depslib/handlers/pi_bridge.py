import json
import pathlib

from ..core import DependencyError, match_one, refresh_hash, replace_exact

NAME = "pi-bridge"
ATTRIBUTE = ".#nixosConfigurations.watson.config.home-manager.users.meatcar.services.cli-proxy-api.piBridge.package"
PACKAGE_ATTRIBUTE = ".#nixosConfigurations.watson.config.home-manager.users.meatcar.services.cli-proxy-api.package.version"
MODULE = "github.com/router-for-me/CLIProxyAPI/v7"


def path(context):
    return context.root / "home-manager/modules/ai/cli-proxy-api/pi-bridge/default.nix"


def nix_string(source, name):
    return match_one(source, rf'^  {name} = "([^"]*)";$')


def bridge_source(context):
    return context.output(
        "nix",
        "eval",
        "--raw",
        "--impure",
        "--expr",
        "let f = builtins.getFlake (toString ./.); in f.inputs.pi-cliproxyapi-bridge.outPath",
    )


def proxy_version(context):
    return context.output("nix", "eval", "--raw", PACKAGE_ATTRIBUTE)


def upstream_bridge_version(context):
    registry_path = pathlib.Path(bridge_source(context)) / "registry.json"
    registry = json.loads(registry_path.read_text())
    return next(
        plugin["version"]
        for plugin in registry["plugins"]
        if plugin["id"] == "pi-bridge"
    )


def check(context):
    source = path(context)
    configured_bridge = nix_string(source, "bridgeVersion")
    upstream_bridge = upstream_bridge_version(context)
    if configured_bridge != upstream_bridge:
        raise DependencyError(
            f"pi-bridge version {configured_bridge} does not match source version {upstream_bridge}"
        )

    configured_proxy = nix_string(source, "cliProxyApiSdkVersion")
    upstream_proxy = proxy_version(context)
    if configured_proxy != upstream_proxy:
        raise DependencyError(
            f"pi-bridge SDK {configured_proxy} does not match CLIProxyAPI {upstream_proxy}"
        )


def update(context):
    context.run("nix", "flake", "update", "pi-cliproxyapi-bridge")
    source = path(context)
    bridge_version = upstream_bridge_version(context)
    sdk_version = proxy_version(context)
    module = json.loads(
        context.output(
            "nix",
            "shell",
            "nixpkgs#go",
            "-c",
            "go",
            "mod",
            "download",
            "-json",
            f"{MODULE}@v{sdk_version}",
        )
    )

    old_bridge = nix_string(source, "bridgeVersion")
    old_sdk = nix_string(source, "cliProxyApiSdkVersion")
    old_module_sum = match_one(source, r'cliProxyApiSdkVersion\} (h1:[^"]*)"')
    old_go_mod_sum = match_one(source, r'cliProxyApiSdkVersion\}/go\.mod (h1:[^"]*)"')
    vendor_hash = match_one(source, r'^    vendorHash = "([^"]*)";$')

    replace_exact(
        source,
        f'bridgeVersion = "{old_bridge}";',
        f'bridgeVersion = "{bridge_version}";',
    )
    replace_exact(
        source,
        f'cliProxyApiSdkVersion = "{old_sdk}";',
        f'cliProxyApiSdkVersion = "{sdk_version}";',
    )
    replace_exact(source, old_module_sum, module["Sum"])
    replace_exact(source, old_go_mod_sum, module["GoModSum"])
    refresh_hash(context, source, vendor_hash, ATTRIBUTE)
    check(context)
