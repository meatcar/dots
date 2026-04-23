#!/usr/bin/env sh
# Pull power-relevant charts from Netdata for a given time window.
# Usage: netdata-pull.sh AFTER_UNIX BEFORE_UNIX [OUT_DIR]
set -eu

AFTER="${1:?AFTER_UNIX required}"
BEFORE="${2:?BEFORE_UNIX required}"
OUT_DIR="${3:-/tmp/netdata-pull-$(date +%s)}"
NETDATA="http://localhost:19999"

mkdir -p "${OUT_DIR}/apps"

fetch() {
  chart="$1"
  out="$2"
  url="${NETDATA}/api/v1/data?chart=${chart}&after=${AFTER}&before=${BEFORE}&format=csv&points=auto&options=nonzero"
  if curl -sf --max-time 10 "${url}" -o "${out}"; then
    lines=$(wc -l <"${out}")
    printf "  %-60s %s lines\n" "${chart}" "${lines}"
  else
    printf "  %-60s FAILED\n" "${chart}" >&2
  fi
}

echo "pulling fixed charts..."
fetch "powersupply_power.BAT0" "${OUT_DIR}/bat_power.csv"
fetch "powersupply_capacity.BAT0" "${OUT_DIR}/bat_capacity.csv"
fetch "sensors.power_amdgpu-pci-c300_power1_PPT_input" "${OUT_DIR}/amdgpu_ppt_input.csv"
fetch "sensors.power_amdgpu-pci-c300_power1_PPT_average" "${OUT_DIR}/amdgpu_ppt_avg.csv"
fetch "sensors.temperature_k10temp-pci-00c3_temp1_Tctl_input" "${OUT_DIR}/cpu_temp.csv"
fetch "sensors.temperature_amdgpu-pci-c300_temp1_edge_input" "${OUT_DIR}/gpu_temp.csv"
fetch "system.cpu" "${OUT_DIR}/system_cpu.csv"
fetch "amdgpu.gpu_utilization_unknown_AMD_GPU_card1" "${OUT_DIR}/gpu_utilization.csv"

echo "pulling per-app cpu charts..."
charts_json=$(curl -sf --max-time 10 "${NETDATA}/api/v1/charts" || echo '{"charts":{}}')
echo "${charts_json}" |
  grep -o '"app\.[^"]*_cpu_utilization"' |
  tr -d '"' |
  sort -u |
  while read -r chart; do
    safe=$(echo "${chart}" | tr './' '__')
    fetch "${chart}" "${OUT_DIR}/apps/${safe}.csv"
  done

echo "done -> ${OUT_DIR}"
