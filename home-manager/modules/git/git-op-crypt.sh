#!/usr/bin/env bash
set -eux -o pipefail

dirname=$(basename "$PWD")
title="git-crypt $dirname"
tags="git-crypt,dev"

usage() {
  echo "Usage: $0 {store|unlock}"
  exit "$1"
}
if [ "$#" -ne 1 ]; then
  usage 1 >&2
fi
case "$1" in
store)
  if op document get "$title" --force >/dev/null 2>&1; then
    echo "Document '$title' already exists. Editing." >&2
    op document edit "$title" .git/git-crypt/keys/default
  else
    echo "Creating new document '$title'." >&2
    op document create .git/git-crypt/keys/default \
      --title "$title" --tags "$tags"
  fi
  ;;
unlock)
  op document get "$title" --out-file .git/git-crypt/keys/default
  git-crypt unlock .git/git-crypt/keys/default
  ;;
-h | --help)
  usage 0
  ;;
*)
  usage 1 >&2
  ;;
esac
