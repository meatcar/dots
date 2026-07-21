#!/usr/bin/env bash
set -euo pipefail

# register our tunnel exit address with the tracker when it changes; the
# endpoint and session cookie live in the secret (a curl config)
conf=${DYNIP_CONF:?}
addr=${TUNNEL_ADDR:?}
state=$XDG_RUNTIME_DIR/qbittorrent.dynip

# one pass: learn the exit ip, register if new. 0 = settled, 1 = retry
try() {
  local ip last resp
  ip=$(curl -4fsS --max-time 10 --interface "$addr" https://icanhazip.com || true)
  [ -n "$ip" ] || return 1
  last=
  [ -f "$state" ] && last=$(cat "$state")
  [ "$ip" = "$last" ] && return 0
  resp=$(curl -4fsS --max-time 10 --interface "$addr" --config "$conf" || true)
  if grep -q '"Success" *: *true' <<<"$resp"; then
    echo "registered $ip"
    printf '%s\n' "$ip" >"$state"
    return 0
  fi
  echo "register failed: ${resp:-no response}" >&2
  return 1
}

check() {
  until try; do sleep 900; done
}

# check once, then sleep on netlink and re-check on any wg0 event; checks
# are idempotent, so event bursts and duplicates are harmless
check
while read -r event; do
  case $event in
  *wg0*)
    sleep 2 # let the tunnel settle
    check
    ;;
  esac
done < <(stdbuf -oL ip -o monitor link address)
