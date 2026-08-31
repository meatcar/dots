from ..core import match_one, refresh_hash

NAME = "paseo"
ATTRIBUTE = ".#nixosConfigurations.watson.config.system.build.toplevel"


def path(context):
    return context.root / "home-manager/modules/paseo/default.nix"


def npm_hash(source):
    return match_one(source, r'^      npmDepsHash = "([^"]*)";$')


def check(context):
    npm_hash(path(context))


def update(context):
    context.run("nix", "flake", "update", "paseo")
    source = path(context)
    refresh_hash(context, source, npm_hash(source), ATTRIBUTE)
