#!/bin/sh
set -eu

# Chromium-family browsers install web-app icons full-bleed square. Round
# their corners in place. Icons whose top-left pixel is already transparent
# are left alone, which also makes reruns no-ops.
dir="${1:-$HOME/.local/share/icons/hicolor}"
radius_pct=22

find "$dir" -regextype posix-extended -type f \
  -regex '.*/apps/[a-z]+-[a-p]{32}-[^/]+\.png' |
  while IFS= read -r icon; do
    # NOTE: fx .a on an image without alpha reads another channel; -alpha set first
    alpha="$(magick "$icon" -alpha set -format '%[fx:p{0,0}.a]' info:)"
    [ "$alpha" = 0 ] && continue

    size="$(magick identify -format '%w %h' "$icon")"
    w="${size% *}"
    h="${size#* }"
    r=$((w * radius_pct / 100))
    tmp="$(dirname "$icon")/.rounding-$(basename "$icon")"

    magick "$icon" -alpha set \
      \( +clone -alpha transparent -fill white \
      -draw "roundrectangle 0,0,$((w - 1)),$((h - 1)),$r,$r" \) \
      -compose DstIn -composite "$tmp"
    mv "$tmp" "$icon"
    echo "rounded web-app icon: $icon"
  done
