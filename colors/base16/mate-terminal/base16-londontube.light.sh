#!/usr/bin/env bash
# Base16 London Tube - Mate Terminal color scheme install script
# Jan T. Sott

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 London Tube Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-londontube-light"
[[ -z "$DCONFTOOL" ]] && DCONFTOOL=dconf
[[ -z "$BASE_KEY" ]] && BASE_KEY=/org/mate/terminal/profiles

PROFILE_KEY="$BASE_KEY/$PROFILE_SLUG"

dset() {
  local key="$1"; shift
  local val="$1"; shift

  "$DCONFTOOL" write "$PROFILE_KEY/$key" "$val"
}

# Because gconftool doesn't have "append"
glist_append() {
  local key="$1"; shift
  local val="$1"; shift

  local entries="$(
    {
      "$DCONFTOOL" read "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
      echo "'$val'"
    } | head -c-1 | tr "\n" ,
  )"

  "$DCONFTOOL" write "$key" "[$entries]"
}

# Append the Base16 profile to the profile list
glist_append /org/mate/terminal/global/profile-list "$PROFILE_SLUG"

dset visible-name "'$PROFILE_NAME'"
dset palette "'#ffffff:#ee2e24:#00853e:#ffd204:#009ddc:#98005d:#85cebc:#d9d8d8:#737171:#ee2e24:#00853e:#ffd204:#009ddc:#98005d:#85cebc:#231f20'"
dset background-color "'#ffffff'"
dset foreground-color "'#5a5758'"
dset bold-color "'#5a5758'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
