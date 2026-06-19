#!/usr/bin/env bash
set -eu -o pipefail

STATE="${XDG_RUNTIME_DIR:-/tmp}/screen-record"
PIDFILE="$STATE/pid"
REC_FILE="$STATE/recording.mkv"
APP="Screen record"
# Replace prior notification in-place on daemons that support the hint.
SYNC=(-h "string:x-canonical-private-synchronous:screen-record")
mkdir -p "$STATE"

notify() { notify-send -a "$APP" "${SYNC[@]}" "$APP" "$1"; }

# Already recording: stop, finalize, compress, save.
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  PID=$(cat "$PIDFILE")
  kill -INT "$PID"
  while kill -0 "$PID" 2>/dev/null; do sleep 0.1; done
  rm -f "$PIDFILE"
  notify "Compressing…"

  OUTFILE="$HOME/Pictures/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4"
  mkdir -p "$(dirname "$OUTFILE")"
  ffmpeg -y -i "$REC_FILE" \
    -c:v libx264 -preset slow -crf 21 -b:v 2M -maxrate 3M -bufsize 4M \
    -c:a aac -b:a 96k -movflags +faststart \
    "$OUTFILE"
  rm -f "$REC_FILE"

  printf 'file://%s' "$OUTFILE" | wl-copy -t text/uri-list
  notify "Saved $OUTFILE (URI copied)"
  exit 0
fi

# Not recording: parse flags and start.
HOTKEY=""
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
  -k)
    HOTKEY="$2"
    shift 2
    ;;
  *)
    echo "Usage: $0 [-g] [-a] [-k HOTKEY]"
    echo "  -g: select a region with slurp"
    echo "  -a: capture audio"
    echo "  -k: hotkey label shown in the start notification"
    exit 1
    ;;
  esac
done

wf-recorder "${WF_RECORDER_ARGS[@]}" -yf "$REC_FILE" &
echo "$!" >"$PIDFILE"

if [ -n "$HOTKEY" ]; then
  notify "● Recording — press $HOTKEY again to stop"
else
  notify "● Recording — run screen-record again to stop"
fi
