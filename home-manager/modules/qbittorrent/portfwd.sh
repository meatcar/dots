#!/usr/bin/env bash
set -euo pipefail

# renew NAT-PMP mappings on the tunnel gateway (the traffic doubles as
# keepalive) and point qbittorrent's listen port at the mapped port
gw=${TUNNEL_GW:?}
api=http://127.0.0.1:8090/api/v2
port=
while :; do
  udp=$(natpmpc -g "$gw" -a 1 0 udp 60 | awk '/Mapped public port/ { print $4 }')
  tcp=$(natpmpc -g "$gw" -a 1 0 tcp 60 | awk '/Mapped public port/ { print $4 }')
  [ "$udp" = "$tcp" ] || echo "udp/tcp mapped ports differ: $udp/$tcp" >&2
  if [ -n "$tcp" ] && [ "$tcp" != "$port" ]; then
    if curl -fsS --max-time 10 "$api/app/setPreferences" \
      --data-urlencode "json={\"listen_port\": $tcp}" >/dev/null; then
      echo "listen_port -> $tcp"
      port=$tcp
    else
      echo "webui unreachable, will retry" >&2
    fi
  fi
  sleep 45
done
