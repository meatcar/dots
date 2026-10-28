import configparser
import json
import os
import re
from pathlib import Path

MAIN = "Desktop Entry"
RESERVED = re.compile(r"[\s\"'\\><~|&;$*?#()`]")


def quote(arg):
    if not RESERVED.search(arg):
        return arg
    assert not re.search(r'["`$\\]', arg), f"Unsupported Exec argument {arg!r}"
    return f'"{arg}"'


source = Path(os.environ["desktopSource"]).read_text()
entry = configparser.ConfigParser(interpolation=None, strict=False)
entry.optionxform = str
entry.read_string(source)

command = entry[MAIN]["Exec"]
assert command.endswith(" %U"), f"Expected trailing URL field in {command!r}"
command = " ".join(
    [command.removesuffix(" %U"), *map(quote, json.loads(os.environ["execArgs"]))]
)
overrides = {"Exec": f"{command} %U", **json.loads(os.environ["overrides"])}
actions = {
    "Desktop Action new-window": f"{command} --new-window %U",
    "Desktop Action new-private-window": f"{command} {os.environ['privateFlag']} %U",
}

section = None
missing = dict(overrides)
remaining = set(actions)
lines = []


def add_missing():
    lines.extend(f"{key}={value}" for key, value in missing.items())
    missing.clear()


for line in source.splitlines():
    if line.startswith("[") and line.endswith("]"):
        if section == MAIN:
            add_missing()
        section = line[1:-1]
    elif section == MAIN:
        key = re.split(r"[=\[]", line, maxsplit=1)[0]
        if key in overrides:
            if not line.startswith(f"{key}="):
                continue  # NOTE: localized variant would hide the override
            line = f"{key}={overrides[key]}"
            missing.pop(key, None)
    elif section in actions and line.startswith("Exec="):
        line = f"Exec={actions[section]}"
        remaining.remove(section)
    lines.append(line)
if section == MAIN:
    add_missing()

assert not remaining, f"Missing browser actions: {remaining}"
Path(os.environ["out"]).write_text("\n".join(lines) + "\n")
