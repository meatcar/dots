from ..core import match_one, refresh_hash, replace_exact

NAME = "hrd"
REPO = "meatcar/hrd"
BRANCH = "fix/tui-root-groups"
ATTRIBUTE = ".#legacyPackages.x86_64-linux.hrd"


def pins(source):
    return (
        match_one(source, r'^  version = "([^"]*)";$'),
        match_one(source, r'^    rev = "([0-9a-f]{40})";$'),
        match_one(source, r'^    hash = "([^"]*)";$'),
        match_one(source, r'^  vendorHash = "([^"]*)";$'),
    )


def check(context):
    pins(context.root / "pkgs/hrd/default.nix")


def update(context):
    source = context.root / "pkgs/hrd/default.nix"
    old_version, old_revision, source_hash, vendor_hash = pins(source)
    commit = context.github(f"/repos/{REPO}/commits/{BRANCH}")
    version = "unstable-" + commit["commit"]["committer"]["date"][:10]
    replace_exact(source, f'version = "{old_version}";', f'version = "{version}";')
    replace_exact(source, f'rev = "{old_revision}";', f'rev = "{commit["sha"]}";')
    refresh_hash(context, source, source_hash, f"{ATTRIBUTE}.src")
    refresh_hash(context, source, vendor_hash, f"{ATTRIBUTE}.goModules")
    check(context)
