import base64
import json

from ..core import match_one, refresh_hash, replace_exact

NAME = "insta360-linux"
REPO = "EdenCoder/insta360-linux"
BRANCH = "main"
ATTRIBUTE = ".#legacyPackages.x86_64-linux.insta360-linux"


def pins(source):
    return (
        match_one(source, r'^  version = "([^"]*)";$'),
        match_one(source, r'^    rev = "([0-9a-f]{40})";$'),
        match_one(
            source,
            r'^  src = fetchFromGitHub \{\n(?:    .*\n)*?    hash = "([^"]*)";$',
        ),
        match_one(
            source,
            r'^  pnpmDeps = fetchPnpmDeps \{\n(?:    .*\n)*?    hash = "([^"]*)";$',
        ),
    )


def check(context):
    pins(context.root / "pkgs/insta360-linux/default.nix")


def update(context):
    source = context.root / "pkgs/insta360-linux/default.nix"
    old_version, old_revision, source_hash, dependency_hash = pins(source)
    commit = context.github(f"/repos/{REPO}/commits/{BRANCH}")
    manifest = context.github(
        f"/repos/{REPO}/contents/package.json?ref={commit['sha']}"
    )
    package_version = json.loads(base64.b64decode(manifest["content"]))["version"]
    date = commit["commit"]["committer"]["date"][:10]
    version = f"{package_version}-unstable-{date}"
    replace_exact(source, f'version = "{old_version}";', f'version = "{version}";')
    replace_exact(source, f'rev = "{old_revision}";', f'rev = "{commit["sha"]}";')
    refresh_hash(context, source, source_hash, f"{ATTRIBUTE}.src")
    refresh_hash(context, source, dependency_hash, f"{ATTRIBUTE}.pnpmDeps")
    check(context)
