#!/usr/bin/env bash
# Import a KDE *.colors scheme into kdeglobals so KDE apps (Dolphin) get correct
# view colors outside Plasma. qgnomeplatform only sets the QPalette; KDE item
# views read their row colors from KColorScheme -> kdeglobals [Colors:*], which
# nothing writes without Plasma, so dark mode shows black/white striped rows
# while the rest of the window is dark. Fed DMS's matugen-generated
# DankMatugen.colors so Dolphin tracks the shell's Material You palette.
#
# Args: $1 = path to a *.colors file, $2 = scheme id (e.g. DankMatugen).
# Only [Colors:*], [ColorEffects:*] and [WM] groups are imported; other
# kdeglobals groups (Dolphin view state, TerminalApplication, ...) are left
# untouched since kwriteconfig6 writes key-by-key.
set -euo pipefail

colors_file=$1
scheme_name=$2
kdeglobals="${XDG_CONFIG_HOME:-$HOME/.config}/kdeglobals"

# DMS may not have generated the scheme yet (first login before matugen runs);
# the path watcher re-fires once it appears.
[[ -r $colors_file ]] || exit 0

group_args=()
import=0
first=""

while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line == \[*\]* ]]; then
    # Header line, possibly nested: [Colors:Header][Inactive].
    group_args=()
    import=0
    first=""
    rest=$line
    while [[ -n $rest ]]; do
      seg=${rest#\[}
      name=${seg%%\]*}
      rest=${seg#*\]}
      [[ -z $first ]] && first=$name
      group_args+=(--group "$name")
    done
    case $first in
    Colors:* | ColorEffects:* | WM) import=1 ;;
    esac
  elif [[ $line == *=* && $import == 1 ]]; then
    kwriteconfig6 --file "$kdeglobals" "${group_args[@]}" \
      --key "${line%%=*}" "${line#*=}"
  fi
done <"$colors_file"

# Record the active scheme and notify running KDE apps to re-read live.
kwriteconfig6 --file "$kdeglobals" --group General --key ColorScheme \
  "$scheme_name" --notify
