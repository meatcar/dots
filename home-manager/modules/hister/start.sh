#!/bin/sh
set -eu

case "${HISTER__APP__ACCESS_TOKEN:-}" in
*[![:space:]]*) ;;
*)
  echo "Hister requires a nonblank hister-access-token Podman secret." >&2
  exit 1
  ;;
esac

umask 077
exec /hister/hister listen
