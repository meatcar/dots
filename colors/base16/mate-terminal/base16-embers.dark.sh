#!/usr/bin/env bash
# Base16 Embers - Mate Terminal color scheme install script
# Jannik Siebert (https://github.com/janniks)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Embers Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-embers-dark"
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
dset palette "'#16130F:#826D57:#57826D:#6D8257:#6D5782:#82576D:#576D82:#A39A90:#5A5047:#826D57:#57826D:#6D8257:#6D5782:#82576D:#576D82:#DBD6D1'"
dset background-color "'#16130F'"
dset foreground-color "'#A39A90'"
dset bold-color "'#A39A90'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
