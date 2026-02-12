#!/usr/bin/env python3
"""Push-to-talk for Handy via evdev.

Usage: handy-ptt KEY_SEMICOLON [KEY_LEFTMETA ...]

Spawned by a keybinding on press. Sends SIGUSR2 to start recording,
waits for any of the given keys to be released, then sends SIGUSR2
to stop recording.
"""

import argparse
import selectors
import signal
import subprocess
import sys

import evdev
from evdev import ecodes

TIMEOUT = 120  # max recording seconds, safety net


def parse_args():
    parser = argparse.ArgumentParser(
        description="Push-to-talk for Handy via evdev. "
        "Sends SIGUSR2 to start recording, waits for any of the given "
        "keys to be released, then sends SIGUSR2 to stop.",
    )
    parser.add_argument(
        "keys",
        nargs="+",
        metavar="KEY",
        help="evdev key name(s) to watch for release (e.g. KEY_SEMICOLON KEY_LEFTMETA)",
    )
    parser.add_argument(
        "-t",
        "--timeout",
        type=int,
        default=TIMEOUT,
        help=f"max recording seconds before auto-stop (default: {TIMEOUT})",
    )
    return parser.parse_args()


def send_sigusr2():
    subprocess.Popen(["pkill", "-USR2", "-n", "handy"])


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
    args = parse_args()
    watch_keys = resolve_keys(args.keys)
    timeout = args.timeout

    keyboards = find_keyboards()
    if not keyboards:
        print("No keyboard devices found", file=sys.stderr)
        sys.exit(1)

    # Start recording
    send_sigusr2()

    # Stop recording on SIGTERM/SIGINT (cleanup if killed)
    def stop(_sig, _frame):
        send_sigusr2()
        sys.exit(0)

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    sel = selectors.DefaultSelector()
    for kb in keyboards:
        sel.register(kb, selectors.EVENT_READ)

    # Wait for any watched key to be released
    try:
        while True:
            ready = sel.select(timeout=timeout)
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
                            send_sigusr2()
                            return
                except OSError:
                    sel.unregister(device)
    finally:
        sel.close()

    # Reached timeout
    send_sigusr2()


if __name__ == "__main__":
    main()
