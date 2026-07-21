#!/usr/bin/env bash
# shellcheck disable=SC2154 # $out and $UCM_SRC come from the nix builder
#
# Anchor the "PCM device is empty or zero" test in alsa-ucm-conf's HDA HDMI macro.
# Unanchored, it also matches any device number containing a 0, so device 10 takes
# the zero branch, loses its ",pcm=10" jack suffix, fails ControlExists, and never
# becomes a UCM device.
#
# --replace-fail aborts the build once upstream fixes this, so it cannot rot quietly.
set -eu

cp -r "$UCM_SRC" "$out"
chmod -R u+w "$out"

substituteInPlace "$out/codecs/hda/hdmi.conf" \
  --replace-fail 'Regex "(^$|0)"' 'Regex "^(|0)$"'
