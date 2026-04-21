#!/usr/bin/env bash
set -euo pipefail

[ "$(id -u)" -eq 0 ] || exec sudo "$0" "$@"

config="${BACKREST_CONFIG:-/var/lib/backrest/config.json}"

if [ $# -eq 0 ]; then
  echo "Usage: restic-backrest <repo-id> [restic args...]" >&2
  echo "Available repos:" >&2
  jq -r '.repos[].id' "$config" >&2
  exit 1
fi

repo_id="$1"
shift

repo=$(jq -r --arg id "$repo_id" '.repos[] | select(.id == $id)' "$config")

if [ -z "$repo" ]; then
  echo "error: repo '$repo_id' not found in $config" >&2
  echo "available repos:" >&2
  jq -r '.repos[].id' "$config" >&2
  exit 1
fi

uri=$(printf '%s' "$repo" | jq -r '.uri')
password=$(printf '%s' "$repo" | jq -r '.password')
mapfile -t extra_env < <(printf '%s' "$repo" | jq -r '.env[]')

exec env RESTIC_REPOSITORY="$uri" RESTIC_PASSWORD="$password" "${extra_env[@]}" restic "$@"
