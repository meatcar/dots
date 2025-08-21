#!/usr/bin/env bash
set -eux -o pipefail

DIR=$(mktemp -d -t screen-record-XXXXXX)
trap 'rm -rf "$DIR"' EXIT

REC_FILE="$DIR/recording.mkv"
COMPRESSED_FILE="$DIR/compressed.mp4"

WF_RECORDER_ARGS=()

while [ "$#" -gt 0 ]; do
  case "$1" in
  -g)
    WF_RECORDER_ARGS+=("--geometry" "$(slurp)")
    shift
    ;;
  -a)
    WF_RECORDER_ARGS+=("--audio")
    shift
    ;;
  *)
    echo "Usage: $0 [-g] [geometry]"
    echo "  -g: Use slurp to select a geometry"
    exit 1
    ;;
  esac
done

wf-recorder "${WF_RECORDER_ARGS[@]}" -yf "$REC_FILE"
ffmpeg -y -i "$REC_FILE" \
  -c:v libx264 -preset slow -crf 21 -b:v 2M -maxrate 3M -bufsize 4M -c:a aac -b:a 96k -movflags +faststart \
  "$COMPRESSED_FILE"

OUTFILE="$HOME/Pictures/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4"
mv "$COMPRESSED_FILE" "$OUTFILE"
echo "file://$OUTFILE" | wl-copy -t text/uri-list
