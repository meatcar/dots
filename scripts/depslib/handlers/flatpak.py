NAME = "flatpak"


def check(context):
    context.run("flatpak", "list", "--user", "--app")


def update(context):
    context.run("flatpak", "update", "--user", "--assumeyes", "--noninteractive")
