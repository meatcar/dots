#!/bin/sh
# Unattended update run: macOS -> flake inputs -> darwin switch (which
# upgrades brew during activation). Run as root by launchd; FLAKE_DIR is
# injected via the plist's EnvironmentVariables (see auto-update.nix).
set -u
: "${FLAKE_DIR:?}"
export PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/sbin:/usr/bin:/bin
export HOME=/var/root

stamp=/var/db/auto-update.stamp
if [ -f "$stamp" ] && [ "$(($(date +%s) - $(stat -f %m "$stamp")))" -lt 259200 ]; then
  exit 0
fi

# wait up to 5 minutes for a default route, then bail quietly
for _ in $(seq 30); do
  route -n get default >/dev/null 2>&1 && break
  sleep 10
done
route -n get default >/dev/null 2>&1 || exit 0

echo "=== auto-update: $(date) ==="

# 1. macOS. Restart-required updates can't be installed unattended on
# Apple Silicon (needs a volume owner); this stages them so the native
# auto-installer only has the reboot left to do.
softwareupdate --install --all || true

# 2 + 3. flake inputs, then switch (upgrades brew during activation).
sudo -u denys -H nix flake update --flake "$FLAKE_DIR" || true
export HOMEBREW_UPGRADE_GREEDY=1
if darwin-rebuild switch --flake "$FLAKE_DIR"; then
  touch "$stamp"
  # commit the lock bump only once it has switched successfully
  git() { sudo -u denys -H /etc/profiles/per-user/denys/bin/git -C "$FLAKE_DIR" "$@"; }
  if ! git diff --quiet -- flake.lock; then
    git commit -m "chore(deps): nix flake update (auto)" -- flake.lock
  fi
fi
