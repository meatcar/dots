NAME = "gearlever"
GEARLEVER = ("flatpak", "run", "it.mijorus.gearlever")


def check(context):
    context.run(*GEARLEVER, "--list-updates")


def update(context):
    # NOTE: Gear Lever skips running apps; close them first to update them.
    context.run(*GEARLEVER, "--update", "--all", "--yes")
