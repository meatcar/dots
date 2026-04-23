#!/usr/bin/env sh
# One-shot system state snapshot. Prints to stdout; redirect to a file.
set -eu

echo "=== baseline $(date -Iseconds) ==="
echo "hostname: $(hostname)"
echo "kernel: $(uname -r)"
echo "cmdline: $(cat /proc/cmdline)"
echo ""

echo "--- battery ---"
BAT=/sys/class/power_supply/BAT0
printf "ac_online:    %s\n" "$(cat /sys/class/power_supply/AC/online 2>/dev/null || echo n/a)"
printf "status:       %s\n" "$(cat "${BAT}/status")"
printf "capacity:     %s%%\n" "$(cat "${BAT}/capacity")"
printf "energy_now:   %s uWh\n" "$(cat "${BAT}/energy_now")"
printf "energy_full:  %s uWh\n" "$(cat "${BAT}/energy_full")"
printf "power_now:    %s uW\n" "$(cat "${BAT}/power_now")"
printf "cycle_count:  %s\n" "$(cat "${BAT}/cycle_count" 2>/dev/null || echo n/a)"
printf "charge_start: %s%%\n" "$(cat "${BAT}/charge_control_start_threshold" 2>/dev/null || echo n/a)"
printf "charge_stop:  %s%%\n" "$(cat "${BAT}/charge_control_end_threshold" 2>/dev/null || echo n/a)"
echo ""

echo "--- cpu ---"
printf "governor:     %s\n" "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
printf "epp:          %s\n" "$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference)"
printf "driver:       %s\n" "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver)"
printf "platform:     %s\n" "$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo n/a)"
freq_sum=0
freq_count=0
for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq; do
  freq_sum=$((freq_sum + $(cat "$f")))
  freq_count=$((freq_count + 1))
done
printf "freq_avg:     %s kHz\n" "$((freq_sum / freq_count))"
echo ""

echo "--- display ---"
BL=/sys/class/backlight/amdgpu_bl1
bl_cur=$(cat "${BL}/brightness")
bl_max=$(cat "${BL}/max_brightness")
printf "backlight:    %s / %s (%s%%)\n" "${bl_cur}" "${bl_max}" "$((bl_cur * 100 / bl_max))"
echo ""

echo "--- amdgpu ppt ---"
for h in /sys/class/hwmon/hwmon*/; do
  name=$(cat "${h}name" 2>/dev/null || true)
  if [ "${name}" = "amdgpu" ]; then
    printf "power_input:  %s uW\n" "$(cat "${h}power1_input" 2>/dev/null || echo n/a)"
    printf "power_avg:    %s uW\n" "$(cat "${h}power1_average" 2>/dev/null || echo n/a)"
  fi
done
echo ""

echo "--- tlp status ---"
tlp-stat -s 2>/dev/null | head -20 || echo "tlp-stat not available"
echo ""

echo "--- radio ---"
rfkill list 2>/dev/null || echo "rfkill not available"
echo ""

echo "--- top processes (cpu%) ---"
ps -eo pid,pcpu,pmem,comm --sort=-pcpu | head -21
echo ""

echo "--- running user services ---"
systemctl list-units --state=running --type=service --user --no-legend 2>/dev/null | wc -l | xargs printf "count: %s\n"
