#!/usr/bin/env sh
# Summarize a record.sh CSV. Usage: analyze.sh <record.csv>
set -eu

CSV="${1:?usage: analyze.sh <record.csv>}"

tmp=$(mktemp)
trap 'rm -f "${tmp}"' EXIT

# Pass 1: summary stats. Battery-draw stats only count on-battery samples,
# since power_now while on AC reflects charge rate, not system load.
awk -F, '
NR == 1 { next }
{
    ts = $1; ac = $2+0; bat_pct = $3+0; bat_uw = $4+0; bat_wh = $5+0; soc_uw = $6+0
    if (n_total == 0) { ts0 = ts; pct0 = bat_pct; wh0 = bat_wh }
    ts1 = ts; pct1 = bat_pct; wh1 = bat_wh
    n_total++

    soc_w = soc_uw / 1e6
    if (n_total == 1 || soc_w < soc_min) soc_min = soc_w
    if (n_total == 1 || soc_w > soc_max) soc_max = soc_w
    soc_sum += soc_w

    if (ac == 0) {
        bat_w = bat_uw / 1e6
        if (n_bat == 0 || bat_w < bat_min) bat_min = bat_w
        if (n_bat == 0 || bat_w > bat_max) bat_max = bat_w
        bat_sum += bat_w
        n_bat++
    } else {
        n_ac++
    }
}
END {
    if (n_total == 0) { print "no data"; exit 1 }
    elapsed = ts1 - ts0
    hh = int(elapsed/3600); mm = int((elapsed%3600)/60); ss = elapsed%60
    printf "=== summary ===\n"
    printf "samples:       %d  (on battery: %d, on AC: %d)\n", n_total, n_bat, n_ac
    printf "duration:      %02d:%02d:%02d\n", hh, mm, ss
    delta_wh = (wh0 - wh1) / 1e6
    direction = (delta_wh >= 0) ? "consumed" : "gained (AC charging)"
    if (delta_wh < 0) delta_wh = -delta_wh
    printf "battery:       %d%% -> %d%%  (%.2f Wh %s)\n", pct0, pct1, delta_wh, direction
    printf "\n"
    if (n_bat > 0) {
        printf "battery draw (W) [on-battery, %d samples]:  avg %6.2f  min %6.2f  max %6.2f\n", n_bat, bat_sum/n_bat, bat_min, bat_max
        printf "high_thresh: %.4f source=bat\n", bat_sum/n_bat * 1.3
    } else {
        printf "battery draw (W):  n/a (no on-battery samples)\n"
        printf "high_thresh: %.4f source=soc\n", soc_sum/n_total * 1.3
    }
    printf "amdgpu PPT   (W) [%d samples]:              avg %6.2f  min %6.2f  max %6.2f\n", n_total, soc_sum/n_total, soc_min, soc_max
}
' "${CSV}" | tee "${tmp}" | grep -v '^high_thresh'

thresh_line=$(grep '^high_thresh' "${tmp}")
thresh=$(echo "${thresh_line}" | awk '{print $2}')
source=$(echo "${thresh_line}" | awk '{print $3}' | cut -d= -f2)

if [ "${source}" = "bat" ]; then
  signal_label="bat"
else
  signal_label="amdgpu PPT"
fi

# Pass 2: top processes during high-power samples.
# When the threshold derives from battery draw, only look at on-battery samples.
echo ""
printf "top processes during high-power samples (%s >= %.1fW, 130%% of avg):\n" "${signal_label}" "${thresh}"
awk -F, -v thresh="${thresh}" -v src="${source}" '
NR == 1 { next }
{
    if (src == "bat" && $2+0 != 0) next
    val = (src == "bat" ? $4 : $6) / 1e6
    if (val >= thresh+0) {
        if ($12 != "") proc[$12]++
        if ($15 != "") proc[$15]++
        if ($18 != "") proc[$18]++
    }
}
END {
    for (p in proc) printf "  %-30s %d\n", p, proc[p]
}
' "${CSV}" | sort -k2 -rn | head -12
