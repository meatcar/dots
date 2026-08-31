import pathlib

from ..core import DependencyError, read_json

NAME = "cachyos-kernel"
REPO = "xddxdd/nix-cachyos-kernel"
CACHE = "https://attic.xuyh0120.win/lantian"
ATTRIBUTE = "linux-cachyos-latest-lto"


def cached(context, revision):
    output = context.output(
        "nix", "eval", "--raw", f"github:{REPO}/{revision}#{ATTRIBUTE}.outPath"
    )
    store_hash = pathlib.Path(output).name[:32]
    status = context.url_status(f"{CACHE}/{store_hash}.narinfo")
    print(
        f"{revision} kernel {pathlib.Path(output).name[33:]} narinfo {status}",
        flush=True,
    )
    return status == 200


def check(context):
    revision = read_json(context.root / "flake.lock")["nodes"]["nix-cachyos-kernel"][
        "locked"
    ]["rev"]
    if not cached(context, revision):
        raise DependencyError(
            f"the locked CachyOS kernel is not available from {CACHE}"
        )


def update(context):
    commits = context.github(f"/repos/{REPO}/commits?per_page=14")
    for commit in commits:
        revision = commit["sha"]
        if cached(context, revision):
            context.run(
                "nix",
                "flake",
                "lock",
                "--override-input",
                "nix-cachyos-kernel",
                f"github:{REPO}/{revision}",
            )
            return
    raise DependencyError("no cached kernel found in the latest 14 commits")
