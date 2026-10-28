#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -gt 1 ]; then
  echo "Usage: annotate-screenshot [PNG_FILE]" >&2
  exit 1
fi

file=""
if [ "$#" -eq 1 ]; then
  file=$(realpath -e -- "$1")
  if [ ! -f "$file" ]; then
    echo "Not a screenshot file: $1" >&2
    exit 1
  fi
else
  for candidate in "$HOME/Pictures/Screenshots/"*.png; do
    [ -f "$candidate" ] || continue
    case "$candidate" in
    *-annotated.png | *-edited-*.png) continue ;;
    esac
    if [ -z "$file" ] || [ "$candidate" -nt "$file" ]; then
      file="$candidate"
    fi
  done
fi

if [ -z "$file" ]; then
  echo "No original screenshots found in $HOME/Pictures/Screenshots" >&2
  notify-send -a "Screenshot annotation" "No screenshots to annotate" \
    "Take a screenshot first, or select a PNG in your file manager."
  exit 1
fi

case "$file" in
*-annotated.png) output="$file" ;;
*) output="${file%.*}-annotated.png" ;;
esac

exec satty --filename "$file" --output-filename "${output//%/%%}"
