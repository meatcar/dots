from ..core import DependencyError, match_one, read_json, release_asset, replace_exact

NAME = "swaync-theme"
REPO = "catppuccin/swaync"
INPUT = "catppuccin-swaync"


def path(context):
    return context.root / "flake.nix"


def release_url(source):
    return match_one(
        source,
        r'url = "(https://github\.com/catppuccin/swaync/releases/download/[^"]*)";',
    )


def check(context):
    expected = release_url(path(context))
    locked = read_json(context.root / "flake.lock")["nodes"][INPUT]["locked"]["url"]
    if locked != expected:
        raise DependencyError(f"{INPUT} is stale in flake.lock")


def update(context):
    source = path(context)
    old_url = release_url(source)
    release = context.latest_release(REPO)
    new_url = release_asset(release, ["catppuccin-mocha.css", "mocha.css"])
    replace_exact(source, old_url, new_url)
    context.run("nix", "flake", "update", INPUT)
    check(context)
