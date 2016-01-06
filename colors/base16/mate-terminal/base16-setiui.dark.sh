#!/usr/bin/env bash
# Base16 Seti UI - Mate Terminal color scheme install script
# 

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Seti UI Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-setiui-dark"
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
dset palette "'#151718:#Cd3f45:#9fca56:#e6cd69:#55b5db:#a074c4:#55dbbe:#d6d6d6:#41535B:#Cd3f45:#9fca56:#e6cd69:#55b5db:#a074c4:#55dbbe:#ffffff'"
dset background-color "'#151718'"
dset foreground-color "'#d6d6d6'"
dset bold-color "'#d6d6d6'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
