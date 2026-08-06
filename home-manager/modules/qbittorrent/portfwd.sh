#!/usr/bin/env bash
set -euo pipefail

# renew NAT-PMP mappings on the tunnel gateway (the traffic doubles as
# keepalive) and point qbittorrent's listen port at the mapped port
gw=${TUNNEL_GW:?}
api=http://127.0.0.1:8090/api/v2
state=$XDG_RUNTIME_DIR/qbittorrent.dynip # dynip records the address we exit from
port=
warned=
while :; do
  udp=$(natpmpc -g "$gw" -a 1 0 udp 60 | awk '/Mapped public port/ { print $4 }')
  tcp=$(natpmpc -g "$gw" -a 1 0 tcp 60 | awk '/Mapped public port/ { print $4 }')
  [ "$udp" = "$tcp" ] || echo "udp/tcp mapped ports differ: $udp/$tcp" >&2

  # the mapping is published on the gateway's public address, which is not
  # always the one we exit from; peers dial the latter, so a split leaves the
  # forward open where nobody knocks. only a different server fixes it.
  pub=$(natpmpc -g "$gw" | awk '/Public IP address/ { print $5 }')
  exit_ip=
  [ -f "$state" ] && exit_ip=$(cat "$state")
  if [ -n "$pub" ] && [ -n "$exit_ip" ] && [ "$pub" != "$exit_ip" ] &&
    [ "$warned" != "$pub/$exit_ip" ]; then
    echo "forward published on $pub but traffic exits $exit_ip: incoming will time out" >&2
    warned=$pub/$exit_ip
  fi
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
