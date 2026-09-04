#!/usr/bin/env bash
# shellcheck disable=SC2154 # $out and $UCM_SRC come from the nix builder
#
# Patches to alsa-ucm-conf HDA HDMI handling. --replace-fail fails the build
# when an upstream anchor changes.
#
# 1. codecs/hda/hdmi.conf: anchor the "device is empty or 0" regex. Unanchored
#    it matches device 10, which loses its ",pcm=10" jack suffix and never
#    becomes a UCM device.
# 2. conf.d/HDA-Intel: enable UCM for HDA cards without an analog codec.
#    Upstream gates HDA UCM on find-card locating an AMD ACP card, which opens
#    every /dev/snd/controlC*. logind grants login ACLs per node, so an
#    HDMI-only card probed before the ACP card's controlC is readable falls
#    back to legacy hdmi-stereo-* profiles. Such a card uses nothing from ACP.

set -eu

cp -r "$UCM_SRC" "$out"
chmod -R u+w "$out"

substituteInPlace "$out/codecs/hda/hdmi.conf" \
  --replace-fail 'Regex "(^$|0)"' 'Regex "^(|0)$"'

hdmi_only="If.hdmionly {
	Condition {
		Type ControlExists
		Control \"name='Master Playback Switch'\"
	}
	False.Define.Use y
}

If.use {"
substituteInPlace "$out/conf.d/HDA-Intel/HDA-Intel.conf" \
  --replace-fail 'If.use {' "$hdmi_only"
