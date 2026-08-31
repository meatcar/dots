import pathlib
import subprocess
import sys
import tempfile
import types
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).parents[1]))

from depslib import cli, core


class FakeContext:
    def __init__(self):
        self.calls = []

    def verify(self):
        self.calls.append("verify")


def handler(name):
    return types.SimpleNamespace(
        NAME=name,
        check=lambda context: context.calls.append(f"check {name}"),
        update=lambda context: context.calls.append(f"update {name}"),
    )


class CliTest(unittest.TestCase):
    def setUp(self):
        self.context = FakeContext()
        self.handlers = {name: handler(name) for name in ("alpha", "beta")}

    def test_check_defaults_to_all_handlers_then_verifies(self):
        self.assertEqual(cli.main(["check"], self.context, self.handlers), 0)
        self.assertEqual(
            self.context.calls,
            ["check alpha", "check beta", "verify"],
        )

    def test_update_runs_selected_handler_then_verifies(self):
        self.assertEqual(cli.main(["update", "beta"], self.context, self.handlers), 0)
        self.assertEqual(self.context.calls, ["update beta", "verify"])

    def test_update_requires_a_target(self):
        with self.assertRaisesRegex(core.DependencyError, "requires a dependency"):
            cli.main(["update"], self.context, self.handlers)

    def test_unknown_dependency_fails(self):
        with self.assertRaisesRegex(
            core.DependencyError, "unknown dependency: missing"
        ):
            cli.main(["check", "missing"], self.context, self.handlers)


class CoreTest(unittest.TestCase):
    def test_replace_exact_is_atomic_and_requires_one_match(self):
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / "source.nix"
            path.write_text('hash = "old";\n')

            core.replace_exact(path, '"old"', '"new"')
            self.assertEqual(path.read_text(), 'hash = "new";\n')

            with self.assertRaisesRegex(
                core.DependencyError, "expected one occurrence"
            ):
                core.replace_exact(path, '"missing"', '"other"')

    def test_refresh_hash_writes_reported_hash(self):
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / "source.nix"
            path.write_text('hash = "sha256-old";\n')
            results = [
                subprocess.CompletedProcess([], 1, "", "got: sha256-new\n"),
                subprocess.CompletedProcess([], 0, "", ""),
            ]
            context = types.SimpleNamespace(run=lambda *args, **kwargs: results.pop(0))

            core.refresh_hash(context, path, "sha256-old", ".#package")

            self.assertEqual(path.read_text(), 'hash = "sha256-new";\n')
            self.assertEqual(results, [])

    def test_refresh_hash_restores_original_on_unrelated_failure(self):
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / "source.nix"
            path.write_text('hash = "sha256-old";\n')
            result = subprocess.CompletedProcess([], 1, "", "compile failed\n")
            context = types.SimpleNamespace(run=lambda *args, **kwargs: result)

            with self.assertRaisesRegex(core.DependencyError, "compile failed"):
                core.refresh_hash(context, path, "sha256-old", ".#package")

            self.assertEqual(path.read_text(), 'hash = "sha256-old";\n')


if __name__ == "__main__":
    unittest.main()
