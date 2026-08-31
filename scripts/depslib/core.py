import base64
import hashlib
import json
import os
import pathlib
import re
import subprocess
import tempfile
import urllib.error
import urllib.request


class DependencyError(RuntimeError):
    pass


class Context:
    def __init__(self, root):
        self.root = pathlib.Path(root)

    def run(self, *command, capture_output=False, check=True):
        try:
            result = subprocess.run(
                command,
                cwd=self.root,
                text=True,
                stdout=subprocess.PIPE if capture_output else None,
                stderr=subprocess.PIPE if capture_output else None,
                check=False,
            )
        except FileNotFoundError as error:
            raise DependencyError(
                f"required command not found: {command[0]}"
            ) from error

        if check and result.returncode:
            output = "\n".join(
                part.strip() for part in (result.stdout, result.stderr) if part
            )
            raise DependencyError(output or f"command failed: {' '.join(command)}")
        return result

    def output(self, *command):
        return self.run(*command, capture_output=True).stdout.strip()

    def github(self, path):
        request = urllib.request.Request(
            f"https://api.github.com{path}",
            headers={
                "Accept": "application/vnd.github+json",
                "User-Agent": "dots-deps",
            },
        )
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                return json.load(response)
        except Exception as error:
            raise DependencyError(
                f"GitHub request failed for {path}: {error}"
            ) from error

    def latest_release(self, repo, include_prereleases=False):
        releases = self.github(f"/repos/{repo}/releases?per_page=30")
        for release in releases:
            if not release["draft"] and (
                include_prereleases or not release["prerelease"]
            ):
                return release
        raise DependencyError(f"no suitable GitHub release found for {repo}")

    def url_status(self, url):
        request = urllib.request.Request(url, headers={"User-Agent": "dots-deps"})
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                return response.status
        except urllib.error.HTTPError as error:
            return error.code
        except urllib.error.URLError as error:
            raise DependencyError(f"request failed for {url}: {error}") from error

    def verify(self):
        self.run(
            "nix",
            "build",
            ".#nixosConfigurations.watson.config.system.build.toplevel",
            "--no-link",
            "--no-write-lock-file",
            "--no-eval-cache",
        )


def read_json(path):
    return json.loads(pathlib.Path(path).read_text())


def match_one(path, pattern):
    matches = re.findall(pattern, pathlib.Path(path).read_text(), flags=re.MULTILINE)
    if len(matches) != 1:
        raise DependencyError(
            f"{path}: expected one match for {pattern!r}, found {len(matches)}"
        )
    return matches[0]


def release_asset(release, names):
    assets = {
        asset["name"]: asset["browser_download_url"] for asset in release["assets"]
    }
    for name in names:
        if name in assets:
            return assets[name]
    raise DependencyError(
        f"release {release['tag_name']} has none of: {', '.join(names)}"
    )


def replace_exact(path, old, new):
    path = pathlib.Path(path)
    text = path.read_text()
    count = text.count(old)
    if count != 1:
        raise DependencyError(
            f"{path}: expected one occurrence of {old!r}, found {count}"
        )

    descriptor, temporary = tempfile.mkstemp(dir=path.parent, prefix=f".{path.name}.")
    try:
        with os.fdopen(descriptor, "w") as output:
            output.write(text.replace(old, new))
        os.chmod(temporary, path.stat().st_mode)
        os.replace(temporary, path)
    except BaseException:
        pathlib.Path(temporary).unlink(missing_ok=True)
        raise


def refresh_hash(context, path, old_hash, attribute):
    seed = os.urandom(32)
    placeholder = "sha256-" + base64.b64encode(hashlib.sha256(seed).digest()).decode()
    quoted_old = f'"{old_hash}"'
    quoted_placeholder = f'"{placeholder}"'
    replace_exact(path, quoted_old, quoted_placeholder)

    try:
        result = context.run(
            "nix",
            "build",
            attribute,
            "--no-link",
            "--no-eval-cache",
            capture_output=True,
            check=False,
        )
        output = "\n".join(part for part in (result.stdout, result.stderr) if part)
        match = re.search(r"\bgot:\s+(sha256-\S+)", output)
        if result.returncode == 0:
            raise DependencyError(f"{attribute} accepted the placeholder hash")
        if not match:
            raise DependencyError(
                output.strip() or f"could not determine the hash for {attribute}"
            )
        new_hash = match.group(1)
    except BaseException:
        replace_exact(path, quoted_placeholder, quoted_old)
        raise

    replace_exact(path, quoted_placeholder, f'"{new_hash}"')
    context.run("nix", "build", attribute, "--no-link", "--no-eval-cache")
