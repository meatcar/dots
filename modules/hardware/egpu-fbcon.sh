#!/usr/bin/env bash
set -eu -o pipefail

# Map text VTs 1-12 to the given framebuffer (usage: egpu-fbcon <fb-number>).
# fbcon draws only on fb0 (the APU) by default, so the boot console never
# reaches eGPU displays. The kernel maps VTs back to fb0 on unplug.
status=0
for vt in 1 2 3 4 5 6 7 8 9 10 11 12; do
  if ! con2fbmap "$vt" "$1"; then
    echo "egpu-fbcon: mapping vt$vt to fb$1 failed" >&2
    status=1
  fi
done
exit "$status"
