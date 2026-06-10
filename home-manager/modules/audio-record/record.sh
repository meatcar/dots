#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${REC_OUT_DIR:-${HOME}/Sync/notes/_inbox/recordings}"
BITRATE="${REC_BITRATE:-96k}"
THRESH="${REC_SILENCE_THRESHOLD:--40dB}"
DUR="${REC_SILENCE_DURATION:-1.0}"

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
finalize() {
  [ "${DONE}" -eq 1 ] && return
  DONE=1

  echo "Stopping…"
  # SIGINT lets pw-record flush and finalize the WAV header before exiting.
  kill -INT "${MIC_PID}" "${SYS_PID}" 2>/dev/null || true
  wait "${MIC_PID}" "${SYS_PID}" 2>/dev/null || true

  TIMESTAMP=$(date +%Y-%m-%dT%H-%M-%S)
  OUT="${OUT_DIR}/recording-${TIMESTAMP}.opus"

  # Mix both legs, then trim leading/trailing silence only (areverse idiom
  # keeps mid-conversation pauses intact).
  FILTER="[0:a][1:a]amix=inputs=2:duration=longest:normalize=0,"
  FILTER+="silenceremove=start_periods=1:start_silence=${DUR}:start_threshold=${THRESH}:detection=peak,"
  FILTER+="areverse,"
  FILTER+="silenceremove=start_periods=1:start_silence=${DUR}:start_threshold=${THRESH}:detection=peak,"
  FILTER+="areverse"

  ffmpeg -y -loglevel warning \
    -i "${MIC_WAV}" \
    -i "${SYS_WAV}" \
    -filter_complex "${FILTER}" \
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

# Block until signalled; || true prevents set -e from triggering on
# signal-interrupted wait.
wait || true
