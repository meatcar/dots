#!/usr/bin/env bash
# Apply the matched dms output profile when displays are (un)plugged.
# DRM connector hotplug emits kernel "change" uevents on the card device,
# readable without root via the udev netlink socket.

# Apply the matched profile once at startup only if the active profile
# doesn't already match the connected outputs (i.e. outputs changed while
# the machine was off). dms.service being active does not mean its IPC is
# ready yet (cf. the 1password gdbus wait above in default.nix), so poll
# for it first.
for _ in $(seq 30); do
  result=$(dms ipc outputs listProfiles 2>/dev/null)
  case "${result}" in
  *" -> "*) break ;;
  # IPC is up but profiles not yet validated (async validateProfiles() may have
  # run before CompositorService.compositor was set); refresh triggers re-validation.
  "No profiles"*) dms ipc outputs refresh 2>/dev/null ;;
  esac
  sleep 1
done
sleep 2 # let output detection settle before trusting the "matched" tag

# If the active profile is already tagged "matched", DMS has loaded the
# right profile for the connected outputs — no switch needed. Only switch
# when the active profile is stale (outputs changed while the machine was off).
list=$(dms ipc outputs listProfiles 2>/dev/null)
active_line=$(printf '%s\n' "${list}" | grep ' \[[^]]*active[^]]*\] ->' | head -n1)
if ! printf '%s\n' "${active_line}" | grep -q 'matched'; then
  dms-toggle-outputs || echo "warning: failed to apply matched profile at startup" >&2
fi

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
