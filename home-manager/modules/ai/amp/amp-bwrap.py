from contextlib import ExitStack
import os
from pathlib import Path
import re
import sys


SSH_FRAGMENTS = (
    "etc/ssh/ssh_config.d/30-libvirt-ssh-proxy.conf",
    "lib/systemd/ssh_config.d/20-systemd-ssh-proxy.conf",
)


def main():
    arguments = sys.argv[1:]
    mounts = []
    with ExitStack() as sources:
        for line in Path("/etc/ssh/ssh_config").read_text().splitlines():
            include = re.match(r"\s*include(?:\s+|=)(.*)$", line, re.IGNORECASE)
            if not include or not any(
                Path(name).name in include[1] for name in SSH_FRAGMENTS
            ):
                continue
            path = include[1].strip()
            if not re.fullmatch(
                r"/nix/store/[a-z0-9]{32}-[A-Za-z0-9+._=-]+/(?:"
                + "|".join(map(re.escape, SSH_FRAGMENTS))
                + ")",
                path,
            ):
                raise ValueError(f"unsupported system SSH Include: {line.strip()}")
            source = sources.enter_context(open(path, "rb"))
            if re.search(
                rb"^\s*include(?:\s|=)", source.read(), re.IGNORECASE | re.MULTILINE
            ):
                raise ValueError(f"nested SSH Includes are not supported in {path}")
            source.seek(0)
            os.set_inheritable(source.fileno(), True)
            mounts.extend(["--ro-bind-data", str(source.fileno()), path])

        separator = arguments.index("--")
        arguments[separator:separator] = mounts
        os.execvp(arguments[0], arguments)


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError) as error:
        sys.exit(f"amp-account: {error}")
