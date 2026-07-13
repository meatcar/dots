#!/bin/sh
# find-cached-cachyos-kernel [--pin]: newest xddxdd/nix-cachyos-kernel rev
# whose kernel is already built on the lantian attic cache. Prints the rev;
# --pin also locks the flake input to it. HEAD usually outruns the cache by
# ~a day, so a plain `nix flake update` reintroduces local LTO kernel builds.
set -eu

repo=xddxdd/nix-cachyos-kernel
cache=https://attic.xuyh0120.win/lantian
attr=linux-cachyos-latest-lto
limit="${LIMIT:-14}"

revs=$(curl -sf "https://api.github.com/repos/$repo/commits?per_page=$limit" | jq -r '.[].sha') || {
  echo "find-cached-cachyos-kernel: can't list $repo commits" >&2
  exit 1
}

while read -r rev; do
  out=$(nix eval --raw "github:$repo/$rev#$attr.outPath" 2>/dev/null) || {
    echo "find-cached-cachyos-kernel: eval failed for $rev, skipping" >&2
    continue
  }
  hash=$(basename "$out" | cut -c1-32)
  code=$(curl -s -o /dev/null -w '%{http_code}' "$cache/$hash.narinfo")
  echo "$rev kernel ${out##*-} narinfo $code" >&2
  if [ "$code" = 200 ]; then
    echo "$rev"
    if [ "${1:-}" = "--pin" ]; then
      nix flake lock --override-input nix-cachyos-kernel "github:$repo/$rev"
    else
      echo "pin: nix flake lock --override-input nix-cachyos-kernel github:$repo/$rev" >&2
    fi
    exit 0
  fi
done <<EOF
$revs
EOF

echo "find-cached-cachyos-kernel: no cached kernel in last $limit revs" >&2
exit 1
