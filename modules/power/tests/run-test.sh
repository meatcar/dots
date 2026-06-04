#!/usr/bin/env sh
# Orchestrate a power measurement run.
# Usage: [sudo] run-test.sh [DURATION_S]
#   DURATION_S: optional, stops after N seconds. Default: run until Ctrl-C.
#   Run as root to also capture periodic powertop snapshots every 5 minutes.
#   After the run (or reboot), run finalize.sh <DIR> to analyse results.
set -eu

DURATION="${1:-0}"
TS=$(date +%s)
# When run via sudo, use the invoking user's home rather than /root
REAL_HOME=$(getent passwd "${SUDO_USER:-$(whoami)}" | cut -d: -f6)
DIR="${REAL_HOME}/Downloads/power-runs/${TS}"
mkdir -p "${REAL_HOME}/Downloads/power-runs"
mkdir -p "${DIR}/netdata"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> power run starting -> ${DIR}"
echo "    duration: ${DURATION}s (0 = until Ctrl-C)"
echo "    finalize: bash ${SCRIPT_DIR}/finalize.sh ${DIR}"
echo ""

# baseline snapshot at start
sh "${SCRIPT_DIR}/baseline.sh" >"${DIR}/baseline.txt"
cat "${DIR}/baseline.txt"
echo ""

# start continuous recorder in background
OUT="${DIR}/record.csv" INTERVAL=30 DURATION="${DURATION}" \
  sh "${SCRIPT_DIR}/record.sh" &
RECORD_PID=$!

# optional: periodic powertop if root
POWERTOP_PID=0
if [ "$(id -u)" -eq 0 ]; then
  echo "==> running as root: capturing powertop every 5 min"
  (
    while kill -0 "${RECORD_PID}" 2>/dev/null; do
      sleep 300
      out="${DIR}/powertop-$(date +%s).html"
      # shellcheck disable=SC2015
      powertop --time=30 --html="${out}" >/tmp/powertop-err 2>&1 &&
        echo "==> powertop -> ${out}" ||
        {
          echo "warn: powertop failed:"
          cat /tmp/powertop-err
        } >&2
    done
  ) &
  POWERTOP_PID=$!
fi

# wait for recorder to finish (SIGINT, duration, or power loss)
wait "${RECORD_PID}" || true

if [ "${POWERTOP_PID}" -ne 0 ]; then
  kill "${POWERTOP_PID}" 2>/dev/null || true
fi

echo ""
echo "==> recording stopped. run finalize.sh to analyse:"
echo "    bash ${SCRIPT_DIR}/finalize.sh ${DIR}"
