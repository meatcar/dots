#!/usr/bin/env bash
set -euo pipefail

if ((EUID != 0)); then
  echo 'Run as root: sudo restic-redu [redu arguments...]' >&2
  exit 1
fi

set -a
# shellcheck source=/dev/null
source @environmentFile@
set +a
RESTIC_CACHE_DIR=@cacheDir@
export RESTIC_CACHE_DIR

exec redu "$@"
