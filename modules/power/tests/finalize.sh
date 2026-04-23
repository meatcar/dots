#!/usr/bin/env sh
# Finalize a power run after recording stops (or after reboot).
# Usage: finalize.sh [RUN_DIR]
#   RUN_DIR: path to a run-test.sh output dir. Defaults to the most recent
#            run in ~/Downloads/power-runs/.
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

REAL_HOME=$(getent passwd "${SUDO_USER:-$(whoami)}" | cut -d: -f6)

if [ -n "${1:-}" ]; then
  DIR="$1"
else
  DIR=$(ls -dt "${REAL_HOME}/Downloads/power-runs"/[0-9]* 2>/dev/null | head -1)
  if [ -z "${DIR}" ]; then
    echo "error: no run dirs found in ~/Downloads/power-runs/" >&2
    exit 1
  fi
  echo "==> using most recent run: ${DIR}"
fi

if [ ! -d "${DIR}" ]; then
  echo "error: not a directory: ${DIR}" >&2
  exit 1
fi

mkdir -p "${DIR}/netdata"

echo "==> finalizing ${DIR}"
echo ""

# end-state baseline
echo "--- baseline (end) ---"
sh "${SCRIPT_DIR}/baseline.sh" | tee "${DIR}/baseline-end.txt"
echo ""

# analysis
if [ -f "${DIR}/record.csv" ]; then
  echo "--- analysis ---"
  sh "${SCRIPT_DIR}/analyze.sh" "${DIR}/record.csv" | tee "${DIR}/analyze.txt"
  echo ""
else
  echo "warn: no record.csv found in ${DIR}" >&2
fi

# netdata pull for the recorded window
ROWS=$(wc -l <"${DIR}/record.csv" 2>/dev/null || echo 0)
if [ "${ROWS}" -gt 1 ]; then
  start_ts=$(awk -F, 'NR==2{print $1}' "${DIR}/record.csv")
  end_ts=$(awk -F, 'END{print $1}' "${DIR}/record.csv")
  echo "--- netdata pull (${start_ts} -> ${end_ts}) ---"
  sh "${SCRIPT_DIR}/netdata-pull.sh" "${start_ts}" "${end_ts}" "${DIR}/netdata" ||
    echo "warn: netdata pull failed (is Netdata running?)" >&2
  echo ""
fi

echo "==> done. results in ${DIR}"
