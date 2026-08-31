import re

from ..core import (
    DependencyError,
    match_one,
    refresh_hash,
    release_asset,
    replace_exact,
)

NAME = "opensessions"
REPO = "Ataraxy-Labs/opensessions"
ATTRIBUTE = ".#legacyPackages.x86_64-linux.opensessions"


def path(context):
    return context.root / "pkgs/opensessions/default.nix"


def version_from_file(source):
    return match_one(source, r'^  version = "([^"]*)";$')


def hashes(source):
    values = re.findall(
        r'^\s*hash = "([^"]*)";$', source.read_text(), flags=re.MULTILINE
    )
    if len(values) != 2:
        raise DependencyError(f"{source}: expected two hashes, found {len(values)}")
    return values


def check(context):
    source = path(context)
    version_from_file(source)
    hashes(source)
    if "releases/download/v${version}/opensessions-sidebar" not in source.read_text():
        raise DependencyError(
            "OpenSessions release binary does not follow its package version"
        )


def update(context):
    source = path(context)
    old_version = version_from_file(source)
    source_hash, binary_hash = hashes(source)
    release = context.latest_release(REPO, include_prereleases=True)
    version = release["tag_name"].removeprefix("v")
    release_asset(release, ["opensessions-sidebar-x86_64-unknown-linux-gnu.tar.gz"])

    replace_exact(source, f'version = "{old_version}";', f'version = "{version}";')
    refresh_hash(context, source, source_hash, f"{ATTRIBUTE}.src")
    refresh_hash(context, source, binary_hash, ATTRIBUTE)
    check(context)
