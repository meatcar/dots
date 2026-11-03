import re

from ..core import DependencyError, match_one, refresh_hash, replace_exact

NAME = "amp-desktop"
INDEX = "https://static.ampcode.com/linux/dists/stable/main/binary-amd64/Packages"
ATTRIBUTE = ".#legacyPackages.x86_64-linux.amp-desktop"


def path(context):
    return context.root / "pkgs/amp-desktop/default.nix"


def pins(source):
    return (
        match_one(source, r'^  version = "([^"]*)";$'),
        match_one(
            source,
            r'^  src = fetchurl \{\n(?:    .*\n)*?    hash = "([^"]*)";$',
        ),
    )


def latest_version(index):
    versions = re.findall(
        r"^Package: amp-desktop\n(?:\S.*\n)*?Version: (\S+)$",
        index,
        flags=re.MULTILINE,
    )
    if len(versions) != 1:
        raise DependencyError(
            f"{INDEX}: expected one amp-desktop entry, found {len(versions)}"
        )
    return versions[0]


def check(context):
    pins(path(context))


def update(context):
    source = path(context)
    old_version, source_hash = pins(source)
    version = latest_version(context.fetch_text(INDEX))
    replace_exact(source, f'version = "{old_version}";', f'version = "{version}";')
    refresh_hash(context, source, source_hash, f"{ATTRIBUTE}.src")
    check(context)
