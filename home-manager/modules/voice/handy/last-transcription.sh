#!/bin/sh
# Copy the most recent Handy transcription to the Wayland clipboard.

db="${XDG_DATA_HOME:-$HOME/.local/share}/com.pais.handy/history.db"

if [ ! -r "$db" ]; then
  echo "handy-last-transcription: no history db at $db" >&2
  exit 1
fi

# Prefer post-processed text when present. -readonly: Handy holds the db
# open in rollback-journal mode; avoid taking locks against it.
text=$(sqlite3 -readonly "$db" "
  SELECT coalesce(nullif(post_processed_text, ''), transcription_text)
  FROM transcription_history
  WHERE transcription_text != ''
  ORDER BY timestamp DESC
  LIMIT 1;
")

if [ -z "$text" ]; then
  echo "handy-last-transcription: history is empty" >&2
  exit 1
fi

printf '%s' "$text" | wl-copy
