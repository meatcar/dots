#!/usr/bin/env bash
set -euo pipefail

# route launcher/magnet activations through the user service so the
# portfwd companion tracks qbittorrent's lifetime
if ! systemctl --user --quiet is-active qbittorrent.service; then
  # no fresh starts on metered; opt in with systemctl --user start qbittorrent
  case $(metered) in
  1 | 3)
    notify-send 'qBittorrent' 'not starting on a metered connection' || true
    exit 0
    ;;
  esac
  systemctl --user start qbittorrent.service
fi
if [ $# -gt 0 ]; then
  # single-instance handoff needs the app up; the webui answering is our
  # readiness signal (grace-capped in case it's disabled)
  for ((i = 0; i < 50; i++)); do
    curl -fsS --max-time 1 http://127.0.0.1:8090/api/v2/app/version >/dev/null 2>&1 && break
    sleep 0.2
  done
  exec qbittorrent "$@"
fi
