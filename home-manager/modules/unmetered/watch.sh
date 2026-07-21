#!/usr/bin/env bash
set -euo pipefail

# drive unmetered.target off nm's metered state. metered stops the target
# (and its PartOf= units, remembered as markers); unmetered restores both.
# opt in on metered by starting a unit manually; that clears its marker.
markers=$XDG_RUNTIME_DIR/unmetered.suspended
mkdir -p "$markers"

netclass() {
  case $(metered) in
  1 | 3) echo metered ;;
  2 | 4) echo unmetered ;;
  *) echo unknown ;;
  esac
}

suspend() {
  local units=() stopped=() unit
  mapfile -t units < <(systemctl --user show -p ConsistsOf --value unmetered.target | tr ' ' '\n' | awk 'NF')
  for unit in "${units[@]}"; do
    if systemctl --user --quiet is-active "$unit"; then
      touch "$markers/$unit"
      stopped+=("$unit")
    fi
  done
  systemctl --user stop unmetered.target
  if [ "${#stopped[@]}" -gt 0 ]; then
    notify-send 'Metered connection' "suspended ${stopped[*]}" || true
  fi
}

restore() {
  local resumed=() unit marker
  systemctl --user start unmetered.target
  for marker in "$markers"/*; do
    [ -e "$marker" ] || continue
    unit=${marker##*/}
    systemctl --user start "$unit" || true
    rm -f "$marker"
    resumed+=("$unit")
  done
  if [ "${#resumed[@]}" -gt 0 ]; then
    notify-send 'Unmetered connection' "resumed ${resumed[*]}" || true
  fi
}

apply() {
  case $1 in
  metered) suspend ;;
  unmetered) restore ;;
  esac
}

# act on transitions only, so manual opt-ins survive dbus noise; each wake
# re-reads the real state, so missed or duplicate signals stay harmless
state=$(netclass)
apply "$state"
while read -r _; do
  now=$(netclass)
  if [ "$now" != "$state" ] && [ "$now" != unknown ]; then
    state=$now
    apply "$now"
  fi
done < <(stdbuf -oL gdbus monitor --system --dest org.freedesktop.NetworkManager \
  --object-path /org/freedesktop/NetworkManager)
