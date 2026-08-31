#!/usr/bin/env bash
# greetd session command; wraps the niri package's niri-session.

# Session stdio points at the VT, where errors hide behind the greeter.
exec > >(tee >(systemd-cat -t niri-session)) 2>&1
echo "start: args=[$*] vt=${XDG_VTNR:-?} session=${XDG_SESSION_ID:-?}"

# greetd only reaches us when no session holds the VT, so with linger on an
# active niri.service is an orphan from a dead leader. Stop it, or upstream
# refuses to start and every login bounces back to the greeter.
if systemctl --user -q is-active niri.service; then
  echo "niri-session: stopping orphaned niri.service left by a dead session" >&2
  systemctl --user stop niri.service
fi

# No exec: stay session leader. Nothing else records the leader's exit
# (scopes are unsupervised, greetd is silent), and upstream's $SHELL -l
# re-exec would make fish the leader. No exit line at all means SIGKILL.
# shellcheck disable=SC2329  # invoked via trap
on_signal() {
  echo "niri-session: leader got SIG$1"
  if [ -n "${child:-}" ]; then kill "$child" 2>/dev/null || true; fi
}
for sig in HUP INT QUIT TERM; do
  # shellcheck disable=SC2064  # expand now: one trap per signal name
  trap "on_signal $sig" "$sig"
done

# the real niri-session: runtimeInputs precede us on PATH
niri-session "$@" &
child=$!
rc=0
wait "$child" || rc=$?
echo "niri-session: exiting rc=$rc (129+ = 128+signal)"
exit "$rc"
