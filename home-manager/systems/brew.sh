#!/usr/bin/env bash
# Shared `brew` wrapper (installed by common.nix). Homebrew is owned by
# denys (nix-homebrew.user), so other users get sudo'd to him,
# authenticating with their own admin password. Successful
# installs/uninstalls are recorded in modules/darwin/brew-extras.json so
# homebrew.onActivation.cleanup doesn't wipe ad-hoc installs on the next
# switch. Requires jq on PATH (provided via runtimeInputs).
set -euo pipefail

BREW=/opt/homebrew/bin/brew
EXTRAS="${NH_FLAKE:-/Users/denys/git/hub/meatcar/dots}/modules/darwin/homebrew/brew-extras.json"

as_denys() {
  if [ "$(id -un)" = denys ]; then "$@"; else /usr/bin/sudo -u denys -H "$@"; fi
}

# first non-flag arg is the subcommand, the rest are package names
sub=""
names=()
for arg in "$@"; do
  case "$arg" in
    -*) ;;
    *) if [ -z "$sub" ]; then sub="$arg"; else names+=("$arg"); fi ;;
  esac
done

as_denys "$BREW" "$@"

case "$sub" in
  install | uninstall | remove | rm) ;;
  *) exit 0 ;;
esac
[ "${#names[@]}" -gt 0 ] || exit 0

update() {
  local out
  out=$(as_denys jq --arg name "$name" "$1" "$EXTRAS")
  printf '%s\n' "$out" | as_denys /usr/bin/tee "$EXTRAS" >/dev/null
}

# shellcheck disable=SC2016  # $name inside single quotes is a jq variable
for name in "${names[@]}"; do
  if [ "$sub" = install ]; then
    if as_denys "$BREW" list --cask "$name" >/dev/null 2>&1; then
      update '.casks = ((.casks + [$name]) | unique)'
    else
      update '.brews = ((.brews + [$name]) | unique)'
    fi
  else
    update '.brews -= [$name] | .casks -= [$name]'
  fi
done
