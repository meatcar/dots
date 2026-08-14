#!/bin/sh
set -eu

backup_names='@backupNames@'

if [ "$#" -eq 0 ]; then
  echo "Usage: restic-job <backup-name> [restic args...]" >&2
  echo "Available backups:" >&2
  printf '%s\n' "$backup_names" >&2
  exit 1
fi

backup=$1
shift

case " $backup_names " in
*" $backup "*) ;;
*)
  echo "error: backup '$backup' is not configured" >&2
  exit 1
  ;;
esac

wrapper="/run/current-system/sw/bin/restic-$backup"
if [ ! -x "$wrapper" ]; then
  echo "error: Restic wrapper for backup '$backup' is unavailable" >&2
  exit 1
fi

exec "$wrapper" "$@"
