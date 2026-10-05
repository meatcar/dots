#!/bin/sh
set -eu

HISTER__APP__ACCESS_TOKEN=$(cat /run/secrets/hister-token)
export HISTER__APP__ACCESS_TOKEN

case "${HISTER__APP__ACCESS_TOKEN:-}" in
*[![:space:]]*) ;;
*)
  echo "Hister requires a nonblank agenix histerToken secret." >&2
  exit 1
  ;;
esac

umask 077
exec /hister/hister listen
