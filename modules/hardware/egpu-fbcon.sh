#!/usr/bin/env bash
set -eu -o pipefail
# Map text VTs 1-12 to the given framebuffer
# fbcon draws only on fb0 (the APU) by default.
# The kernel maps VTs back to fb0 on unplug.

fb="$1"
status=0
for vt in 1 2 3 4 5 6 7 8 9 10 11 12; do
  if ! con2fbmap "$vt" "$fb"; then
    echo "egpu-fbcon: mapping vt$vt to fb$fb failed" >&2
    status=1
  fi
done
exit "$status"
