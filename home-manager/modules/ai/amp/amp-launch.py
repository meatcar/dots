import os
import sys


def runner_defaults(arguments: list[str], runner: str, directory: str) -> list[str]:
    if not runner:
        return []
    if arguments and not arguments[0].startswith("-"):
        return []

    has_runner_directory = False
    for argument in arguments:
        if argument == "--":
            break
        if argument == "--executor" or argument.startswith("--executor="):
            return []
        if argument == "--runner-dir" or argument.startswith("--runner-dir="):
            has_runner_directory = True

    defaults = ["--executor", f"runner:{runner}"]
    if not has_runner_directory:
        defaults.extend(["--runner-dir", directory])
    return defaults


if __name__ == "__main__":
    command, runner, directory, *arguments = sys.argv[1:]
    defaults = runner_defaults(arguments, runner, directory)
    os.execv(command, [command, *defaults, *arguments])
