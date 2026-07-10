#!/usr/bin/env bash
set -euo pipefail

# Follows netdata alert transitions pushed into the journal by custom_sender
# (see modules/netdata/health_alarm_notify.conf). The cursor file is
# journalctl's own exactly-once bookkeeping across restarts; --lines=0
# skips history on the very first run.
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/netdata-notify"
mkdir -p "${STATE_DIR}"

journalctl --identifier=netdata-alert --follow --output=json \
  --lines=0 --cursor-file="${STATE_DIR}/cursor" |
  jq --unbuffered -r '.MESSAGE' |
  while IFS=$'\t' read -r ts _host name transition chart value; do
    status="${transition##*->}"
    case "${status}" in
    WARNING) urgency=normal ;;
    CRITICAL) urgency=critical ;;
    *) continue ;;
    esac
    notify-send --urgency="${urgency}" --app-name=netdata \
      "netdata ${status}: ${name}" "${chart} is at ${value} (${ts})" || true
  done
