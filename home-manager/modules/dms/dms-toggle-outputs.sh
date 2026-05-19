#!/bin/sh
# Switch dms output profiles.
# Default: apply the profile matching the connected outputs.
# --rotate: apply the next profile in the list, wrapping around.

usage() {
  echo "usage: ${0##*/} [--rotate]" >&2
}

mode=matched
case "${1-}" in
"") ;;
--rotate) mode=rotate ;;
*)
  usage
  exit 2
  ;;
esac

# Lines look like: name [active,matched] -> ["eDP-1",...]
list=$(dms ipc outputs listProfiles)
if [ -z "${list}" ]; then
  echo "error: no output profiles configured" >&2
  exit 1
fi

case "${mode}" in
matched)
  target=$(printf '%s\n' "${list}" |
    sed -n 's/^\(.*\) \[[^][]*matched[^][]*\] ->.*$/\1/p' |
    head -n1)
  if [ -z "${target}" ]; then
    echo "error: no profile matches the connected outputs; profiles:" >&2
    printf '%s\n' "${list}" >&2
    exit 1
  fi
  ;;
rotate)
  active=$(printf '%s\n' "${list}" |
    sed -n 's/^\(.*\) \[[^][]*active[^][]*\] ->.*$/\1/p' |
    head -n1)
  target=$(printf '%s\n' "${list}" |
    sed 's/ ->.*//; s/ \[[^][]*\]$//' |
    awk -v cur="${active}" '
      { names[NR] = $0; if ($0 == cur) idx = NR }
      END {
        if (NR == 0) exit 1
        if (idx) print names[idx % NR + 1]; else print names[1]
      }')
  if [ -z "${target}" ]; then
    echo "error: could not determine next profile" >&2
    exit 1
  fi
  ;;
esac

dms ipc outputs setProfile "${target}"
