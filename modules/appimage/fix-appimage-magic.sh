#!/usr/bin/env bash
set -euo pipefail

# Some self-updaters ship AppImages with the type-2 magic ('AI\2' at
# offset 8) zeroed out, so binfmt_misc and appimage-run reject them as
# "Not an AppImage file". Restore the marker on any zeroed file.
dir="${1:-$HOME/AppImages}"
for f in "$dir"/*.appimage; do
  [ -f "$f" ] || continue
  magic="$(od -An -t x1 -j 8 -N 3 "$f" | tr -d ' \n')"
  case "$magic" in
  414901 | 414902) ;; # already tagged
  000000)
    printf 'AI\002' | dd of="$f" bs=1 seek=8 count=3 conv=notrunc status=none
    echo "restored AppImage magic: $f"
    ;;
  *)
    echo "$f: unexpected bytes at offset 8 ($magic), leaving alone" >&2
    ;;
  esac
done
