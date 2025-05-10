#!/usr/bin/env bash
# based on: https://github.com/antipatico/nixos-thinkpad-t14-gen5-amd-tweaks/blob/b2aec538015f956fc4417caf8d7197acdf744a53/modules/nixos/services/t14-micmuteled/default.nix
# update: rewrite polling to event-based.
#          use `pw-cli -m` to monitor changes, `pw-dump` to get mute status
# TODO:   use pw-dump --monitor over pw-mon, as the former outputs json
set -eu -o pipefail

LED_BRIGHTNESS="$1"
AUDIO_USER_ID="$2"

export PIPEWIRE_RUNTIME_DIR="/run/user/$AUDIO_USER_ID"

get_mic_status() {
  pw-dump "$1" |
    jq -r '.[] | select(.type == "PipeWire:Interface:Device") | .info.params.Route[] | select(.direction == "Input") | .props.mute'
}

update_mic_led() {
  local device="$1"
  local mute_status=$(get_mic_status "$device")
  echo Device ID: "$device" Muted: "$mute_status" >&2

  if [ "$mute_status" = "true" ]; then
    echo 1 >"$LED_BRIGHTNESS"
  else
    echo 0 >"$LED_BRIGHTNESS"
  fi
}

cleanstate() {
  # state transitions: block => device => direction => input => mute
  export STATE=""
  export DEVICE_ID=""
  export MUTE_STATUS=""
}
cleanstate

# Monitor PipeWire events
PIPEWIRE_RUNTIME_DIR="/run/user/$AUDIO_USER_ID" pw-mon -p | while read -r line; do
  if [[ $line == "" ]]; then
    cleanstate
  elif [[ $line =~ ^(changed|added): ]]; then
    STATE="block"
  elif [[ $STATE == "block" && $line =~ ^id:\ ([0-9]+) ]]; then
    STATE="device"
    DEVICE_ID="${BASH_REMATCH[1]}"
  elif [[ $STATE == "device" && $line =~ ^Prop:\ key\ Spa:Pod:Object:Param:Route:direction\ \(2\) ]]; then
    STATE="direction"
  elif [[ $STATE == "direction" && $line =~ ^Id\ 0\ +\(Spa:Enum:Direction:Input\) ]]; then
    STATE="input"
  fi

  if [[ $STATE == "input" ]]; then
    update_mic_led "$DEVICE_ID"
    cleanstate
  fi
done
