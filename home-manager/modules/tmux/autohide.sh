#!/usr/bin/env sh
# NOTE: recomputes all targets; a hook's own target falls back to the attached client.
set -eu

usage() {
  echo "usage: tmux_autohide {status|pane-border} SOCKET" >&2
  exit 2
}

what=${1:-}
socket=${2:-}
[ -n "$socket" ] || usage

# NOTE: run-shell leaves $TMUX unset; an inherited one targets the wrong server.
tmux() { command tmux -S "$socket" "$@"; }

# NOTE: _os_stash is opensessions' sidebar parking session.
mine='#{!=:#{session_name},_os_stash}'

# NOTE: fires per resize step, so skip no-ops; targets vanish mid-loop.
case "$what" in
status)
  tmux list-sessions -f "$mine" \
    -F '#{session_id} #{status} #{?#{>:#{session_windows},1},on,off}' |
    while read -r id current want; do
      [ "$current" = "$want" ] || tmux set-option -t "$id" status "$want" || :
    done
  ;;
pane-border)
  tmux list-windows -a -f "$mine" \
    -F '#{window_id} #{pane-border-status} #{?#{>:#{window_panes},1},top,off}' |
    while read -r id current want; do
      [ "$current" = "$want" ] || tmux set-option -w -t "$id" pane-border-status "$want" || :
    done
  ;;
*) usage ;;
esac
