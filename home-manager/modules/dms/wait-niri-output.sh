#!/bin/sh
# wait-niri-output [seconds]: block until niri reports at least one enabled
# output (a line with "Current mode:").
#
# The DMS backend binds wlr-gamma-control only for the outputs that exist when
# it starts, and never retries. Starting before niri has enumerated a monitor
# permanently drops the "gamma" capability for that process, so night mode
# reports "DMS gamma control is not available" until the service is restarted.
# Gate startup on an output being present, then gamma binds on the first try.
#
# Polls every 0.2s; exits non-zero on timeout so systemd's Restart keeps polling
# rather than starting the shell without gamma.
timeout="${1:-30}"
max=$((timeout * 5))
i=0
while [ "$i" -lt "$max" ]; do
  if niri msg outputs 2>/dev/null | grep -q 'Current mode:'; then
    exit 0
  fi
  sleep 0.2
  i=$((i + 1))
done
echo "wait-niri-output: no enabled niri output after ${timeout}s" >&2
exit 1
