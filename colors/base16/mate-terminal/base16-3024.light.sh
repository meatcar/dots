#!/usr/bin/env bash
# Base16 3024 - Mate Terminal color scheme install script
# Jan T. Sott (http://github.com/idleberg)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 3024 Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-3024-light"
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
dset palette "'#f7f7f7:#db2d20:#01a252:#fded02:#01a0e4:#a16a94:#b5e4f4:#a5a2a2:#5c5855:#db2d20:#01a252:#fded02:#01a0e4:#a16a94:#b5e4f4:#090300'"
dset background-color "'#f7f7f7'"
dset foreground-color "'#4a4543'"
dset bold-color "'#4a4543'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
