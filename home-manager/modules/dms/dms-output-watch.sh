#!/usr/bin/env bash
# Apply the matched dms output profile when displays are (un)plugged.
# DRM connector hotplug emits kernel "change" uevents on the card device,
# readable without root via the udev netlink socket.

# Apply the matched profile once at startup: outputs may have changed while
# the machine was off, leaving a stale profile active. dms.service being
# active does not mean its IPC is ready yet (cf. the 1password gdbus wait
# above in default.nix), so poll for it first.
for _ in $(seq 30); do
  if dms ipc outputs listProfiles 2>/dev/null | grep -q ' -> '; then
    break
  fi
  sleep 1
done
sleep 2 # let output detection settle before trusting the "matched" tag
dms-toggle-outputs || echo "warning: failed to apply matched profile at startup" >&2

# Lines look like: KERNEL[1234.5678] change /devices/.../drm/card1 (drm)
stdbuf -oL udevadm monitor --kernel --subsystem-match=drm |
  while read -r tag action _; do
    case "${tag} ${action}" in
    "KERNEL["*" change") ;;
    *) continue ;;
    esac
    # Give the compositor a moment to register the connector change,
    # then drain the event burst so one hotplug triggers one switch.
    sleep 1
    while read -r -t 0.1 _; do :; done
    dms-toggle-outputs || echo "warning: failed to apply matched profile" >&2
  done
