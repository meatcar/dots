from ..core import DependencyError, match_one, read_json, release_asset, replace_exact

NAME = "cpa-manager-plus"
REPO = "seakee/CPA-Manager-Plus"
INPUTS = {
    "amd64": "cpa-manager-plus-amd64",
    "arm64": "cpa-manager-plus-arm64",
}


def paths(context):
    return (
        context.root / "flake.nix",
        context.root / "home-manager/modules/ai/cli-proxy-api/manager-plus/default.nix",
    )


def version_from_module(module):
    return match_one(module, r'^  version = "([^"]*)";$')


def release_url(version, architecture):
    return (
        f"https://github.com/{REPO}/releases/download/v{version}/"
        f"cpa-manager-plus_v{version}_linux_{architecture}.tar.gz"
    )


def check(context):
    flake, module = paths(context)
    version = version_from_module(module)
    flake_text = flake.read_text()
    lock = read_json(context.root / "flake.lock")
    for architecture, input_name in INPUTS.items():
        url = release_url(version, architecture)
        if f'url = "{url}";' not in flake_text:
            raise DependencyError(
                f"{input_name} does not match CPA Manager Plus {version}"
            )
        try:
            locked_url = lock["nodes"][input_name]["locked"]["url"]
        except KeyError as error:
            raise DependencyError(f"{input_name} is missing from flake.lock") from error
        if locked_url != url:
            raise DependencyError(f"{input_name} is stale in flake.lock")


def update(context):
    flake, module = paths(context)
    old_version = version_from_module(module)
    release = context.latest_release(REPO)
    version = release["tag_name"].removeprefix("v")
    urls = {
        architecture: release_asset(
            release,
            [f"cpa-manager-plus_v{version}_linux_{architecture}.tar.gz"],
        )
        for architecture in INPUTS
    }

    replace_exact(module, f'version = "{old_version}";', f'version = "{version}";')
    for architecture in INPUTS:
        replace_exact(flake, release_url(old_version, architecture), urls[architecture])
    context.run("nix", "flake", "update", *INPUTS.values())
    check(context)
