#!/bin/sh
# NOTE: logind counts only enabled connectors; those are off under DPMS and after resume.
# Internal connector types per drm_connector_enum_list in drm_connector.c.
for status in /sys/class/drm/card*-*/status; do
  case "${status#/sys/class/drm/card*-}" in
  eDP-* | LVDS-* | DSI-* | DPI-* | Writeback-* | Virtual-*) continue ;;
  esac
  read -r state <"$status" || continue
  if [ "$state" = connected ]; then
    systemctl stop --no-block clamshell-release.timer
    systemctl start --no-block clamshell-inhibit.service
    exit 0
  fi
done
# NOTE: connectors flap on resume; debounce the release.
systemctl start --no-block clamshell-release.timer
