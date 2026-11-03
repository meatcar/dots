#!/bin/sh
set -eu

signature='Signature: 8a477f597d28d172789f06886806bc55'

if [ "$#" -eq 0 ]; then
  echo 'Usage: cachedir-tag DIRECTORY...' >&2
  exit 2
fi

for dir; do
  if [ ! -d "$dir" ]; then
    printf 'cachedir-tag: not a directory: %s\n' "$dir" >&2
    exit 1
  fi

  tag="$dir/CACHEDIR.TAG"
  if [ -L "$tag" ] || { [ -e "$tag" ] && [ ! -f "$tag" ]; }; then
    printf 'cachedir-tag: not a regular file: %s\n' "$tag" >&2
    exit 1
  fi
  if [ -f "$tag" ]; then
    if [ "$(head -c 43 "$tag")" != "$signature" ]; then
      printf 'cachedir-tag: invalid tag; refusing to replace: %s\n' "$tag" >&2
      exit 1
    fi
    printf 'Already tagged: %s\n' "$dir"
  else
    printf '%s\n' "$signature" >"$tag"
    printf 'Tagged: %s\n' "$dir"
  fi
done
