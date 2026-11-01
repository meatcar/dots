from ..core import match_one, refresh_hash, replace_exact

NAME = "pipewire-control-center"
REPO = "knightinfected/PipeWireController"
ATTRIBUTE = ".#legacyPackages.x86_64-linux.pipewire-control-center"


def pins(source):
    return (
        match_one(source, r'^  version = "([^"]*)";$'),
        match_one(
            source,
            r'^  src = fetchFromGitHub \{\n(?:    .*\n)*?    hash = "([^"]*)";$',
        ),
    )


def check(context):
    pins(context.root / "pkgs/pipewire-control-center/default.nix")


def update(context):
    source = context.root / "pkgs/pipewire-control-center/default.nix"
    old_version, source_hash = pins(source)
    version = context.latest_release(REPO)["tag_name"].removeprefix("v")
    replace_exact(source, f'version = "{old_version}";', f'version = "{version}";')
    refresh_hash(context, source, source_hash, f"{ATTRIBUTE}.src")
    check(context)
