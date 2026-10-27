#!/bin/sh
# Sleep, wake by RTC alarm, and report PASS/FAIL from the journal.
set -eu

usage() {
  cat <<EOF
usage: sleep-smoke [-o OPERATION] [-w WAKE_SEC] [-d DELAY_SEC]

  -o  suspend | hibernate | hybrid-sleep | suspend-then-hibernate (default)
  -w  seconds until the RTC alarm wakes the machine (default: 120, 300 for s-t-h)
  -d  HibernateDelaySec for suspend-then-hibernate (default: 60)

Run as root, ideally detached so a dropped shell does not kill it:
  sudo systemd-run --unit=sleep-smoke sleep-smoke
  journalctl -u sleep-smoke
EOF
}

op=suspend-then-hibernate
wake=
delay=60
while getopts o:w:d:h flag; do
  case $flag in
  o) op=$OPTARG ;;
  w) wake=$OPTARG ;;
  d) delay=$OPTARG ;;
  *)
    usage
    exit 2
    ;;
  esac
done

case $op in
suspend | hibernate | hybrid-sleep) : "${wake:=120}" ;;
suspend-then-hibernate) : "${wake:=300}" ;;
*)
  echo "sleep-smoke: unknown operation '$op'" >&2
  usage >&2
  exit 2
  ;;
esac

if [ "$(id -u)" -ne 0 ]; then
  echo "sleep-smoke: run as root (needs the RTC alarm and a sleep.conf drop-in)" >&2
  exit 1
fi

dropin=/run/systemd/sleep.conf.d/50-sleep-smoke.conf
cleanup() { rm -f "$dropin"; }
trap cleanup EXIT INT TERM

if [ "$op" = suspend-then-hibernate ]; then
  mkdir -p "${dropin%/*}"
  printf '[Sleep]\nHibernateDelaySec=%s\nHibernateOnACPower=yes\n' "$delay" >"$dropin"
fi

start=$(date '+%Y-%m-%d %H:%M:%S')
t0=$(date +%s)
echo "sleep-smoke: $op at $start, RTC wake in ${wake}s"
rtcwake -m no -s "$wake"
systemctl "$op"

# NOTE: no grep -q; an early exit breaks the pipe on long logs.
has() { printf '%s\n' "$1" | grep -E "$2" >/dev/null; }

# NOTE: own stdout lands in the journal; read only other identifiers, never all.
journal() {
  journalctl -q -o short-iso --since "$start" \
    -t kernel -t systemd-sleep -t systemd-logind "$@"
}

deadline=$((t0 + wake + 600))
result=
while [ "$(date +%s)" -lt "$deadline" ]; do
  sleep 5
  log=$(journal)
  if has "$log" "Failed to (put system to sleep|suspend|hibernate)|Sleep operation .* failed"; then
    result="FAIL: sleep operation failed"
    break
  fi
  if has "$log" "System returned from sleep operation"; then
    result=PASS
    break
  fi
done
elapsed=$(($(date +%s) - t0))

report=$(journal --grep "Performing sleep|returned from sleep|Failed to (put|suspend|hibernate|freeze)|PM: .*error|PM: (suspend|hibernation) (entry|exit)|PM: hibernation: hibernation (entry|exit)|PM: hibernation: (Allocated|Image|Wrote|Read)|PM: Image|Freezing .* (completed|failed)|resume of devices complete|wakeup|GPIO [0-9]+ is active" || true)
printf '%s\n' "$report"

if [ -z "$result" ]; then
  result="FAIL: no return within $((wake + 600))s"
elif [ "$result" = PASS ] && [ "$elapsed" -lt $((wake - 5)) ]; then
  result="FAIL: woke after ${elapsed}s, before the ${wake}s RTC alarm (see wakeup lines)"
elif [ "$result" = PASS ] && [ "$op" = suspend-then-hibernate ] &&
  ! has "$report" "PM: hibernation: hibernation exit"; then
  result="FAIL: returned without hibernating"
fi
echo "sleep-smoke: $result: $op (${elapsed}s)"
[ "$result" = PASS ]
