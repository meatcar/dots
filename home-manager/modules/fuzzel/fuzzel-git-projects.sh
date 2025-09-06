#!/usr/bin/env bash
set -eux -o pipefail

if [ "$#" -eq 0 ]; then
  echo "usage: $0 [cmd line]" >&2
  echo "       run a command in a zoxide directory" >&2
  exit 1
fi
cmd=$*

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
fifo="$tmp/fifo"
mkfifo "$fifo"

cd /git
{
  zoxide query --list
  fd --glob .git --hidden --type directory --max-depth 10 --exec 'dirname'
} >>"$fifo" &
dir=$(fuzzel -d <"$fifo")
zoxide add "$dir" || true
cd "$dir"

$cmd
# if [ -f ".envrc" ]; then
#   # shellcheck disable=SC2086
#   direnv exec . $cmd
# else
#   $cmd
# fi
