#!/bin/sh
# wait-wayland [seconds]: block until $WAYLAND_DISPLAY's socket appears.
# Default 30s, polls every 0.2s; exits non-zero naming the missing socket.
timeout="${1:-30}"
sock="${XDG_RUNTIME_DIR:?}/${WAYLAND_DISPLAY:?}"
max=$((timeout * 5))
i=0
while [ "$i" -lt "$max" ]; do
  [ -S "$sock" ] && exit 0
  sleep 0.2
  i=$((i + 1))
done
echo "wait-wayland: $sock never appeared after ${timeout}s" >&2
exit 1
