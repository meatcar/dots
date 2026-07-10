#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${REC_OUT_DIR:-${HOME}/Sync/notes/_inbox/recordings}"
BITRATE="${REC_BITRATE:-96k}"
THRESH="${REC_SILENCE_THRESHOLD:--40dB}"
DUR="${REC_SILENCE_DURATION:-1.0}"
LOUDNESS="${REC_LOUDNESS:--16}"

# Any args become a filename label: lowercased, non-alphanumerics to dashes.
SLUG=$(printf '%s' "$*" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9' '-' | tr -s '-')
SLUG="${SLUG#-}"
SLUG="${SLUG%-}"

mkdir -p "${OUT_DIR}"
DIR=$(mktemp -d -t audio-record-XXXXXX)
MIC_WAV="${DIR}/mic.wav"
SYS_WAV="${DIR}/system.wav"

# Mic leg: WirePlumber relinks this stream whenever the default source changes.
pw-record --target auto "${MIC_WAV}" &
MIC_PID=$!

# System leg: stream.capture.sink=true routes to the default sink's monitor;
# WirePlumber relinks it when the default output changes (headphone plug, etc).
pw-record --target auto \
  -P '{ "stream.capture.sink": "true" }' \
  "${SYS_WAV}" &
SYS_PID=$!

DONE=0
# A bare WAV header is 44 bytes; anything larger means real samples landed.
have_audio() { [ -s "$1" ] && [ "$(stat -c %s "$1")" -gt 44 ]; }

finalize() {
  [ "${DONE}" -eq 1 ] && return
  DONE=1

  echo "Stopping…"
  # SIGINT lets pw-record flush and finalize the WAV header before exiting.
  kill -INT "${MIC_PID}" "${SYS_PID}" 2>/dev/null || true
  wait "${MIC_PID}" "${SYS_PID}" 2>/dev/null || true

  # Neither leg linked a source: don't write an empty file or claim success.
  if ! have_audio "${MIC_WAV}" && ! have_audio "${SYS_WAV}"; then
    echo "No audio captured; nothing to save." >&2
    notify-send "Recording failed" "No audio was captured" || true
    rm -rf "${DIR}"
    return
  fi

  TIMESTAMP=$(date +%Y-%m-%dT%H-%M-%S)
  OUT="${OUT_DIR}/recording-${TIMESTAMP}${SLUG:+-${SLUG}}.opus"

  MIX="[0:a][1:a]amix=inputs=2:duration=longest:normalize=0"

  # Trim leading/trailing silence only (mid-conversation pauses stay).
  # The areverse idiom buffers the whole stream in RAM twice and OOMs on
  # multi-hour recordings; detect bounds in a streaming pass instead.
  BOUNDS=$(ffmpeg -nostdin -hide_banner -y \
    -i "${MIC_WAV}" \
    -i "${SYS_WAV}" \
    -filter_complex "${MIX},silencedetect=noise=${THRESH}:d=${DUR}" \
    -f null - 2>&1 | awk '
      /^ *Duration:/ { split($2, t, ":"); d = t[1]*3600 + t[2]*60 + t[3]
                       if (d > total) total = d }
      /silence_start:/ { s[++n] = $NF }
      /silence_end:/   { e[n] = $5 }
      END {
        start = 0; end = total
        if (n && s[1] < 0.1 && e[1] != "") start = e[1]
        # trailing silence: no end logged, or it coincides with EOF
        if (n && (e[n] == "" || total - e[n] < 0.1)) end = s[n]
        if (end <= start) { start = 0; end = total }
        print start, end
      }')
  read -r TRIM_START TRIM_END <<<"${BOUNDS}"

  ffmpeg -nostdin -y -loglevel warning \
    -i "${MIC_WAV}" \
    -i "${SYS_WAV}" \
    -filter_complex "${MIX},atrim=start=${TRIM_START}:end=${TRIM_END},asetpts=PTS-STARTPTS,loudnorm=I=${LOUDNESS}:TP=-1.5:LRA=11,aresample=48000" \
    -c:a libopus -b:a "${BITRATE}" -application audio \
    "${OUT}"

  rm -rf "${DIR}"
  echo "Saved: ${OUT}"
  notify-send "Recording saved" "${OUT}" || true
}

trap finalize INT TERM EXIT

echo "Recording… Ctrl-C to stop."
printf "  mic:    %s\n" "${MIC_WAV}"
printf "  system: %s\n" "${SYS_WAV}"
if [ -n "${SLUG}" ]; then printf "  label:  %s\n" "${SLUG}"; fi

# Block until signalled; || true prevents set -e from triggering on
# signal-interrupted wait.
wait || true
