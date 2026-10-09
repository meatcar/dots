from ..core import match_one, refresh_hash, replace_exact

NAME = "figma-console-mcp"
REPO = "southleft/figma-console-mcp"
ATTRIBUTE = ".#legacyPackages.x86_64-linux.figma-console-mcp"


def pins(source):
    return (
        match_one(source, r'^  version = "([^"]*)";$'),
        match_one(
            source,
            r'^  src = fetchFromGitHub \{\n(?:    .*\n)*?    hash = "([^"]*)";$',
        ),
        match_one(source, r'^  npmDepsHash = "([^"]*)";$'),
    )


def check(context):
    pins(context.root / "pkgs/figma-console-mcp/default.nix")


def update(context):
    source = context.root / "pkgs/figma-console-mcp/default.nix"
    old_version, source_hash, dependency_hash = pins(source)
    version = context.latest_release(REPO)["tag_name"].removeprefix("v")
    replace_exact(source, f'version = "{old_version}";', f'version = "{version}";')
    refresh_hash(context, source, source_hash, f"{ATTRIBUTE}.src")
    refresh_hash(context, source, dependency_hash, f"{ATTRIBUTE}.npmDeps")
    check(context)
