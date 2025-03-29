# Source: https://github.com/YaLTeR/niri/discussions/352#discussioncomment-12489627
from subprocess import Popen, PIPE
import sys
import json


def get_selection(input_list, prompt="") -> str:
    """Get selection from list"""
    lines = str(min(len(input_list), 8))
    with Popen(
        ["fuzzel", "--dmenu", "-l", lines, "-p", prompt],
        stdin=PIPE,
        stdout=PIPE,
        stderr=PIPE,
    ) as fuzzel:
        selection = fuzzel.communicate(
            input=bytes("\n".join(input_list), "utf-8"))[0]
        if fuzzel.returncode != 0:
            sys.exit(1)
        return selection.decode().strip()


def get_windows():
    niri_windows = Popen(["niri", "msg", "-j", "windows"],
                         stdout=PIPE, text=True)
    windows = json.loads(niri_windows.stdout.read())
    windows.sort(key=lambda window: window["id"])
    return windows


def make_selection_list(windows):
    return list(
        map(
            lambda window: f"{window['id']}) {window['app_id']}: {window['title']}",
            windows,
        )
    )


def choose_selected_window(selection):
    id = selection.split(")")[0]
    Popen(["niri", "msg", "action", "focus-window", "--id", f"{id}"])


windows = get_windows()
selection_list = make_selection_list(windows)
selection = get_selection(selection_list, "🪟 > ")
choose_selected_window(selection)
