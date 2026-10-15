#!/bin/sh
# Unattended update run, as root via launchd. Each job runs at most once per
# period (its stamp holds the last period attempted), so hourly launches catch
# up after sleep, power-off, or no network. FLAKE_DIR and OWNER come from the
# plist's EnvironmentVariables (see default.nix).
set -u
: "${FLAKE_DIR:?}" "${OWNER:?}"
export PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/sbin:/usr/bin:/sbin:/bin
export HOME=/var/root

brew=/opt/homebrew/bin/brew
git=/etc/profiles/per-user/$OWNER/bin/git

log() { echo "$(date '+%F %T') $*"; }

# NOTE: sudo resets PATH, so commands run as OWNER use absolute paths.
as_owner() { sudo -u "$OWNER" -H "$@"; }

# $1 job, $2 date(1) format naming the period
due() { [ "$(cat "/var/db/auto-update.$1.stamp" 2>/dev/null)" != "$(date "+$2")" ]; }
mark() { date "+$2" >"/var/db/auto-update.$1.stamp"; }

brew_upgrade() {
  as_owner "$brew" update &&
    as_owner "$brew" upgrade --greedy &&
    as_owner "$brew" cleanup
}

# flake inputs, then switch (activation also runs brew bundle)
system_update() {
  as_owner "$(command -v nix)" flake update --flake "$FLAKE_DIR" || return
  darwin-rebuild switch --flake "$FLAKE_DIR" || return
  if ! as_owner "$git" -C "$FLAKE_DIR" diff --quiet -- flake.lock; then
    as_owner "$git" -C "$FLAKE_DIR" commit -m "chore(deps): nix flake update (auto)" -- flake.lock
  fi
}

# $1 job, $2 period format, $3 function
run() {
  due "$1" "$2" || return 0
  log "$1: start"
  if "$3"; then
    log "$1: ok"
  else
    log "$1: FAILED (exit $?), retry next period"
  fi
  mark "$1" "$2"
}

due brew %F || due system %G-%V || exit 0

i=0
until route -n get default >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "$i" -gt 30 ]; then
    log "no network after 5 min, retry next hour"
    exit 1
  fi
  sleep 10
done

# keep the Mac awake until this script exits
caffeinate -i -w $$ &

run brew %F brew_upgrade
run system %G-%V system_update
