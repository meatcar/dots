#!/usr/bin/env bash
set -euo pipefail

# NOTE: secret is a curl config with the endpoint and a bootstrap session cookie
conf=${DYNIP_CONF:?}
addr=${TUNNEL_ADDR:?}
jar=${DYNIP_JAR:?}
rev=${DYNIP_REV:?}
state=$XDG_RUNTIME_DIR/qbittorrent.dynip

umask 077
mkdir -p "$(dirname "$jar")"

# NOTE: new secret is a new session; drop old cookie and ip. No record keeps the jar.
if [ -f "$jar.rev" ] && [ "$(cat "$jar.rev")" != "$rev" ]; then
  rm -f "$jar" "$state"
fi
printf '%s\n' "$rev" >"$jar.rev"

# NOTE: tracker reissues the cookie; seeded jar is the live session. Never send jar and secret together.
url=$(grep -oE 'https://[^"'"'"' ]+' "$conf" | head -1)
[ -n "$url" ] || {
  echo "no endpoint url in $conf" >&2
  exit 1
}

# NOTE: empty jar has only comments; HttpOnly cookie lines also start with #
seeded() { [ -f "$jar" ] && grep -qE '^(#HttpOnly_)?[^#[:space:]]' "$jar"; }

register() {
  if seeded; then
    curl -4sS --max-time 10 --interface "$addr" -b "$jar" -c "$jar" "$url"
  else
    curl -4sS --max-time 10 --interface "$addr" --config "$conf" -c "$jar"
  fi
}

# NOTE: 0 = settled, 1 = retry
try() {
  local ip last resp
  ip=$(curl -4fsS --max-time 10 --interface "$addr" https://icanhazip.com || true)
  [ -n "$ip" ] || return 1
  last=
  [ -f "$state" ] && last=$(cat "$state")
  [ "$ip" = "$last" ] && return 0
  # NOTE: no -f; tracker gives the refusal reason in the body
  resp=$(register || true)
  if grep -q '"Success" *: *true' <<<"$resp"; then
    echo "registered $ip"
    printf '%s\n' "$ip" >"$state"
    return 0
  fi
  # NOTE: tracker rejects this cookie; next try uses the secret
  case $resp in
  *"Invalid Cookie"* | *"No Session Cookie"*) rm -f "$jar" ;;
  esac
  echo "register failed: ${resp:-no response}" >&2
  return 1
}

# NOTE: tracker allows one change per rolling hour; faster retries get 429
check() {
  until try; do sleep 3600; done
}

# NOTE: checks are idempotent; wg0 event bursts are harmless
check
while read -r event; do
  case $event in
  *wg0*)
    sleep 2 # NOTE: tunnel settles
    check
    ;;
  esac
done < <(stdbuf -oL ip -o monitor link address)
