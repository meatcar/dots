#!/usr/bin/env sh
# NOTE: recomputes all windows; a hook's own target falls back to the attached client.
set -eu

usage() {
  echo "usage: tmux_window_chrome SOCKET" >&2
  exit 2
}

socket=${1:-}
[ -n "$socket" ] || usage

# NOTE: run-shell leaves $TMUX unset; an inherited one targets the wrong server.
tmux() { command tmux -S "$socket" "$@"; }

# NOTE: _os_stash is opensessions' sidebar parking session, sized 200x200.
mine='#{!=:#{session_name},_os_stash}'

# Left-edge sidebar width. Empty if absent or on the right. NOTE: +3 is the
# border column plus the 2 tmux inserts before a pane-border pill, so the window
# pill lands in the same column as the pill under it.
sidebar='#{P:#{?#{&&:#{==:#{pane_title},opensessions-sidebar},#{==:#{pane_left},0}},#{e|+:#{pane_width},3},}}'

# NOTE: session_name stays a format so a window linked into two sessions names
# the one on screen. tmux.conf renders this via #{E:@os_pad}, one expansion, so
# a literal # needs ### as it would inline.
label='#{?session_grouped,@#{session_group},###{session_name}}#{l: }'

# NOTE: fires per resize step, so skip no-ops; targets vanish mid-loop.
tmux list-windows -a -f "$mine" \
  -F "#{window_id} #{pane-border-status} #{?#{>:#{window_panes},1},top,off} $sidebar|#{@os_pad}" |
  while read -r id border_is border_want rest; do
    [ "$border_is" = "$border_want" ] ||
      tmux set-option -w -t "$id" pane-border-status "$border_want" || :

    width=${rest%%|*}
    pad_is=${rest#*|}
    # NOTE: p only pads, = only truncates; both needed to pin a width.
    if [ -n "$width" ]; then
      pad_want="#{p$width:#{=$width:$label}}"
    else
      pad_want="$label"
    fi
    [ "$pad_is" = "$pad_want" ] || {
      tmux set-option -w -t "$id" @os_pad "$pad_want" || :
      # NOTE: run-shell -b lands after the redraw; others catch up on status-interval.
      tmux refresh-client -S || :
    }
  done
