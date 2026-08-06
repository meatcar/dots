#!/usr/bin/env bash
set -euo pipefail

# register our tunnel exit address with the tracker when it changes; the
# endpoint and bootstrap session cookie live in the secret (a curl config)
conf=${DYNIP_CONF:?}
addr=${TUNNEL_ADDR:?}
jar=${DYNIP_JAR:?}
state=$XDG_RUNTIME_DIR/qbittorrent.dynip

umask 077
mkdir -p "$(dirname "$jar")"

# the tracker reissues the session cookie, so once seeded the jar is the
# live session and the secret is only a bootstrap. sending both at once
# puts two session cookies in one header, so they must never be combined.
url=$(grep -oE 'https://[^"'"'"' ]+' "$conf" | head -1)
[ -n "$url" ] || {
  echo "no endpoint url in $conf" >&2
  exit 1
}

# a jar curl wrote but the tracker set nothing in is all comments; httponly
# cookies are themselves comment-prefixed, so match those too
seeded() { [ -f "$jar" ] && grep -qE '^(#HttpOnly_)?[^#[:space:]]' "$jar"; }

register() {
  if seeded; then
    curl -4sS --max-time 10 --interface "$addr" -b "$jar" -c "$jar" "$url"
  else
    curl -4sS --max-time 10 --interface "$addr" --config "$conf" -c "$jar"
  fi
}

# one pass: learn the exit ip, register if new. 0 = settled, 1 = retry
try() {
  local ip last resp
  ip=$(curl -4fsS --max-time 10 --interface "$addr" https://icanhazip.com || true)
  [ -n "$ip" ] || return 1
  last=
  [ -f "$state" ] && last=$(cat "$state")
  [ "$ip" = "$last" ] && return 0
  # no -f here: the tracker explains refusals in the body, and -f discards it
  resp=$(register || true)
  if grep -q '"Success" *: *true' <<<"$resp"; then
    echo "registered $ip"
    printf '%s\n' "$ip" >"$state"
    return 0
  fi
  # a cookie the tracker won't decode is spent; fall back to the secret
  case $resp in
  *"Invalid Cookie"* | *"No Session Cookie"*) rm -f "$jar" ;;
  esac
  echo "register failed: ${resp:-no response}" >&2
  return 1
}

# the tracker allows one change per rolling hour; retrying faster earns 429s
check() {
  until try; do sleep 3600; done
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
