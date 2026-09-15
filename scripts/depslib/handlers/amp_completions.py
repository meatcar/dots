from ..core import DependencyError, read_json

NAME = "amp-completions"


def check(context):
    pinned = read_json(context.root / "flake.lock")["nodes"][NAME]
    if pinned.get("flake") is not False:
        raise DependencyError(f"{NAME} must be a non-flake input")


def update(context):
    context.run("nix", "flake", "update", NAME)
    check(context)
