from ..core import match_one, refresh_hash, replace_exact

NAME = "hrd"
REPO = "hugoh/hrd"
ATTRIBUTE = ".#legacyPackages.x86_64-linux.hrd"


def pins(source):
    return (
        match_one(source, r'^  version = "([^"]*)";$'),
        match_one(source, r'^    hash = "([^"]*)";$'),
        match_one(source, r'^  vendorHash = "([^"]*)";$'),
    )


def check(context):
    pins(context.root / "pkgs/hrd/default.nix")


def update(context):
    source = context.root / "pkgs/hrd/default.nix"
    old_version, source_hash, vendor_hash = pins(source)
    version = context.latest_release(REPO)["tag_name"].removeprefix("v")
    replace_exact(source, f'version = "{old_version}";', f'version = "{version}";')
    refresh_hash(context, source, source_hash, f"{ATTRIBUTE}.src")
    refresh_hash(context, source, vendor_hash, f"{ATTRIBUTE}.goModules")
    check(context)
