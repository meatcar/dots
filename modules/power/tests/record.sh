#!/usr/bin/env sh
# Continuous unprivileged sensor logger. Outputs CSV to $OUT.
# Usage: [INTERVAL=30] [DURATION=0] [OUT=/tmp/power-run-<ts>.csv] record.sh
#   INTERVAL: seconds between samples (default 30)
#   DURATION: total seconds to run, 0 = run until SIGINT (default 0)
#   OUT: output CSV file path
set -eu

INTERVAL="${INTERVAL:-30}"
DURATION="${DURATION:-0}"
OUT="${OUT:-/tmp/power-run-$(date +%s).csv}"

HEADER="ts_unix,ac_online,bat_pct,bat_power_uw,bat_energy_uwh,soc_power_now_uw,soc_power_avg_uw,cpu_freq_avg_khz,backlight_pct,top1_pid,top1_cpu,top1_comm,top2_pid,top2_cpu,top2_comm,top3_pid,top3_cpu,top3_comm"

BAT=/sys/class/power_supply/BAT0
BL=/sys/class/backlight/amdgpu_bl1
bl_max=$(cat "${BL}/max_brightness")

AMDGPU_HWMON=""
for h in /sys/class/hwmon/hwmon*/; do
  name=$(cat "${h}name" 2>/dev/null || true)
  if [ "${name}" = "amdgpu" ]; then
    AMDGPU_HWMON="${h}"
    break
  fi
done

if [ -z "${AMDGPU_HWMON}" ]; then
  echo "warn: amdgpu hwmon not found, soc_power columns will be 0" >&2
fi

if [ ! -f "${OUT}" ]; then
  echo "${HEADER}" >"${OUT}"
fi

stop=0
trap 'stop=1' INT TERM

start_ts=$(date +%s)

printf "recording to %s (interval=%ss)\n" "${OUT}" "${INTERVAL}" >&2

while [ "${stop}" -eq 0 ]; do
  ts=$(date +%s)

  # battery
  ac=$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo 0)
  bat_pct=$(cat "${BAT}/capacity")
  bat_power=$(cat "${BAT}/power_now")
  bat_energy=$(cat "${BAT}/energy_now")

  # amdgpu PPT
  if [ -n "${AMDGPU_HWMON}" ]; then
    soc_now=$(cat "${AMDGPU_HWMON}power1_input" 2>/dev/null || echo 0)
    soc_avg=$(cat "${AMDGPU_HWMON}power1_average" 2>/dev/null || echo 0)
  else
    soc_now=0
    soc_avg=0
  fi

  # avg cpu freq across all cores
  freq_sum=0
  freq_count=0
  for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq; do
    freq_sum=$((freq_sum + $(cat "$f")))
    freq_count=$((freq_count + 1))
  done
  cpu_freq=$((freq_sum / freq_count))

  # backlight %
  bl_cur=$(cat "${BL}/brightness")
  bl_pct=$((bl_cur * 100 / bl_max))

  # top 3 processes (exclude ps itself)
  # shellcheck disable=SC2009
  top3=$(ps -eo pid,pcpu,comm --sort=-pcpu --no-headers 2>/dev/null |
    grep -v ' ps$' | head -3)
  t1=$(echo "${top3}" | sed -n '1p')
  t2=$(echo "${top3}" | sed -n '2p')
  t3=$(echo "${top3}" | sed -n '3p')

  p1=$(echo "${t1}" | awk '{print $1}')
  c1=$(echo "${t1}" | awk '{print $2}')
  n1=$(echo "${t1}" | awk '{print $3}')
  p2=$(echo "${t2}" | awk '{print $1}')
  c2=$(echo "${t2}" | awk '{print $2}')
  n2=$(echo "${t2}" | awk '{print $3}')
  p3=$(echo "${t3}" | awk '{print $1}')
  c3=$(echo "${t3}" | awk '{print $2}')
  n3=$(echo "${t3}" | awk '{print $3}')

  printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" \
    "${ts}" "${ac}" "${bat_pct}" "${bat_power}" "${bat_energy}" \
    "${soc_now}" "${soc_avg}" "${cpu_freq}" "${bl_pct}" \
    "${p1}" "${c1}" "${n1}" \
    "${p2}" "${c2}" "${n2}" \
    "${p3}" "${c3}" "${n3}" \
    >>"${OUT}"

  if [ "${DURATION}" -gt 0 ] && [ $((ts - start_ts)) -ge "${DURATION}" ]; then
    break
  fi

  if [ "${stop}" -eq 0 ]; then
    sleep "${INTERVAL}"
  fi
done

printf "done. %s\n" "${OUT}" >&2
