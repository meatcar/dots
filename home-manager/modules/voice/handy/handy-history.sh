#!/usr/bin/env bash
set -eu -o pipefail

# Fuzzy-pick a Handy transcription from history, then copy it to the
# clipboard or type it at the cursor.

if [ "$#" -ne 1 ] || { [ "$1" != copy ] && [ "$1" != type ]; }; then
  echo "usage: $0 <copy|type>" >&2
  exit 1
fi
mode=$1

db="${XDG_DATA_HOME:-$HOME/.local/share}/com.pais.handy/history.db"
if [ ! -r "$db" ]; then
  echo "handy-history: no history db at $db" >&2
  exit 1
fi

# -readonly: Handy holds the db open in rollback-journal mode; avoid
# taking locks against it. Prefer post-processed text when present.
q() { sqlite3 -readonly "$db" "$1"; }

list=$(q "
  SELECT id || ' │ ' || datetime(timestamp, 'unixepoch', 'localtime') || ' │ ' ||
         replace(replace(coalesce(nullif(post_processed_text, ''), transcription_text),
                 char(13), ' '), char(10), ' ')
  FROM transcription_history
  WHERE transcription_text != ''
  ORDER BY timestamp DESC;
")

if [ -z "$list" ]; then
  echo "handy-history: history is empty" >&2
  exit 1
fi

sel=$(printf '%s\n' "$list" | fuzzel --dmenu --width 100 --prompt "$mode 🎙 ") || exit 0
id=${sel%% *}
case "$id" in
'' | *[!0-9]*)
  echo "handy-history: bad selection: $sel" >&2
  exit 1
  ;;
esac

text=$(q "
  SELECT coalesce(nullif(post_processed_text, ''), transcription_text)
  FROM transcription_history
  WHERE id = $id;
")

case "$mode" in
copy)
  printf '%s' "$text" | wl-copy
  ;;
type)
  sleep 0.2 # let focus return to the previous window after fuzzel closes
  printf '%s\n' "$text" | {
    first=1
    while IFS= read -r line; do
      if [ "$first" = 1 ]; then first=0; else echo 'key enter'; fi
      printf 'type %s\n' "$line"
    done
  } | dotool
  ;;
esac
