import configparser
import os
from pathlib import Path

source = Path(os.environ["desktopSource"]).read_text()
entry = configparser.ConfigParser(interpolation=None, strict=False)
entry.optionxform = str
entry.read_string(source)

command = entry["Desktop Entry"]["Exec"]
assert command.endswith(" %U"), f"Expected trailing URL field in {command!r}"
command = command.removesuffix(" %U")
actions = {
    "Desktop Action new-window": f"{command} --new-window %U",
    "Desktop Action new-private-window": f"{command} {os.environ['privateFlag']} %U",
}

section = None
remaining = set(actions)
lines = []
for line in source.splitlines():
    if line.startswith("[") and line.endswith("]"):
        section = line[1:-1]
    if section in actions and line.startswith("Exec="):
        line = f"Exec={actions[section]}"
        remaining.remove(section)
    lines.append(line)

assert not remaining, f"Missing browser actions: {remaining}"
Path(os.environ["out"]).write_text("\n".join(lines) + "\n")
