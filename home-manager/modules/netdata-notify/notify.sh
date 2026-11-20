#!/usr/bin/env bash
set -euo pipefail

# Follows netdata alert transitions pushed into the journal by custom_sender
# (see modules/netdata/health_alarm_notify.conf). The cursor file is
# journalctl's own exactly-once bookkeeping across restarts; --lines=0
# skips history on the very first run.
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/netdata-notify"
mkdir -p "${STATE_DIR}"

# Starts the space audit in an Amp thread on each rise of btrfs_space_audit.
# The marker blocks re-triggers until the alert clears.
# Unset SPACE_AUDIT_THREAD disables it.
space_audit_edge() {
  [[ -n ${SPACE_AUDIT_THREAD:-} ]] || return 0
  local raised="${STATE_DIR}/space-audit-raised"
  case "${1}" in
  CLEAR) rm -f "${raised}" ;;
  WARNING | CRITICAL)
    [[ ! -e ${raised} ]] || return 0
    touch "${raised}"
    {
      "${SPACE_AUDIT_AMP}" threads continue "${SPACE_AUDIT_THREAD}" -ox \
        "netdata alert btrfs_space_audit is ${1}: ${2} at ${3} used. Run one space audit cycle as described in this thread's saved schedule prompt (get_schedule)." \
        >>"${STATE_DIR}/space-audit.log" 2>&1 ||
        echo "netdata-notify: space audit trigger failed, see ${STATE_DIR}/space-audit.log" >&2
    } &
    ;;
  esac
}

journalctl --identifier=netdata-alert --follow --output=json \
  --lines=0 --cursor-file="${STATE_DIR}/cursor" |
  jq --unbuffered -r '.MESSAGE' |
  while IFS=$'\t' read -r ts _host name transition chart value; do
    status="${transition##*->}"
    if [[ ${name} == btrfs_space_audit ]]; then
      space_audit_edge "${status}" "${chart}" "${value}"
    fi
    case "${status}" in
    WARNING) urgency=normal ;;
    CRITICAL) urgency=critical ;;
    *) continue ;;
    esac
    # literal <br> keeps DMS from markdown-rendering the body, which
    # would eat the underscores in chart names as italics
    notify-send --urgency="${urgency}" --app-name=netdata \
      "netdata ${status}: ${name}" "${chart} is at ${value}<br>(${ts})" || true
  done
