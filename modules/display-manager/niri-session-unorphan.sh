#!/usr/bin/env bash
# greetd runs this to start the session. With users.*.linger on, a session
# whose leader dies (eGPU undock, greetd hiccup) leaves niri.service running
# with no seat; upstream niri-session then refuses to start ("A niri session
# is already running"), bouncing every login back to the greeter. greetd only
# shows the greeter when no session holds its VT, so an active niri.service
# here is always such an orphan: stop it, then hand off.

# greetd points session stdio at the VT, where errors vanish behind the
# greeter on a failed login; mirror everything from here down (including the
# real niri-session and its systemctl calls) into the journal.
exec > >(tee >(systemd-cat -t niri-session)) 2>&1
echo "start: args=[$*] vt=${XDG_VTNR:-?} session=${XDG_SESSION_ID:-?}"

if systemctl --user -q is-active niri.service; then
  echo "niri-session: stopping orphaned niri.service left by a dead session" >&2
  systemctl --user stop niri.service
fi
# resolves to the real niri-session: runtimeInputs precede us on PATH
exec niri-session "$@"
