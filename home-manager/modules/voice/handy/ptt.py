#!/usr/bin/env python3
"""Generic push-to-talk via evdev.

Usage: ptt KEY [KEY ...] -- COMMAND [ARGS ...]

Runs COMMAND on start, monitors evdev for any of the listed keys
to be released, then runs COMMAND again.
"""

import selectors
import signal
import subprocess
import sys

import evdev
from evdev import ecodes

TIMEOUT = 120  # max recording seconds, safety net


def parse_args():
    argv = sys.argv[1:]
    if "--" not in argv:
        print("Usage: ptt KEY [KEY ...] -- COMMAND [ARGS ...]", file=sys.stderr)
        sys.exit(1)
    sep = argv.index("--")
    key_names = argv[:sep]
    command = argv[sep + 1 :]
    if not key_names:
        print("No keys specified", file=sys.stderr)
        sys.exit(1)
    if not command:
        print("No command specified", file=sys.stderr)
        sys.exit(1)
    return key_names, command


def resolve_keys(names):
    codes = set()
    for name in names:
        code = ecodes.ecodes.get(name)
        if code is None:
            print(f"Unknown key: {name}", file=sys.stderr)
            sys.exit(1)
        codes.add(code)
    return codes


def find_keyboards():
    keyboards = []
    for path in evdev.list_devices():
        device = evdev.InputDevice(path)
        caps = device.capabilities()
        if ecodes.EV_KEY in caps:
            keys = caps[ecodes.EV_KEY]
            if ecodes.KEY_A in keys and ecodes.KEY_Z in keys:
                keyboards.append(device)
    return keyboards


def main():
    key_names, command = parse_args()
    watch_keys = resolve_keys(key_names)

    keyboards = find_keyboards()
    if not keyboards:
        print("No keyboard devices found", file=sys.stderr)
        sys.exit(1)

    def run():
        subprocess.Popen(command)

    # Start
    run()

    # Stop on SIGTERM/SIGINT
    def stop(_sig, _frame):
        run()
        sys.exit(0)

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    sel = selectors.DefaultSelector()
    for kb in keyboards:
        sel.register(kb, selectors.EVENT_READ)

    try:
        while True:
            ready = sel.select(timeout=TIMEOUT)
            if not ready:
                break
            for key, _ in ready:
                device = key.fileobj
                try:
                    for event in device.read():
                        if (
                            event.type == ecodes.EV_KEY
                            and event.code in watch_keys
                            and event.value == 0
                        ):
                            run()
                            return
                except OSError:
                    sel.unregister(device)
    finally:
        sel.close()

    # Reached timeout
    run()


if __name__ == "__main__":
    main()
