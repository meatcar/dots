import importlib
import pkgutil

from . import handlers
from .core import DependencyError


def discover_handlers():
    discovered = {}
    for module_info in pkgutil.iter_modules(handlers.__path__, f"{handlers.__name__}."):
        module = importlib.import_module(module_info.name)
        discovered[module.NAME] = module
    return dict(sorted(discovered.items()))


def main(arguments, context, available=None):
    if available is None:
        available = discover_handlers()
    if not arguments:
        raise DependencyError("usage: scripts/deps list|check|update")

    command, *targets = arguments
    if command == "list":
        if targets:
            raise DependencyError("list does not accept dependency names")
        print(*available, sep="\n")
        return 0
    if command not in {"check", "update"}:
        raise DependencyError(f"unknown command: {command}")
    if command == "update" and not targets:
        raise DependencyError("update requires a dependency name or --all")
    if targets == ["--all"] or (command == "check" and not targets):
        targets = list(available)
    elif "--all" in targets:
        raise DependencyError("--all cannot be combined with dependency names")

    for name in targets:
        if name not in available:
            raise DependencyError(f"unknown dependency: {name}")
        print(f"==> {command} {name}", flush=True)
        getattr(available[name], command)(context)

    print("==> verify watson", flush=True)
    context.verify()
    return 0
