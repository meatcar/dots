#!/usr/bin/env bash
# Base16 Codeschool - Mate Terminal color scheme install script
# brettof86

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Codeschool Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-codeschool-light"
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
dset palette "'#b5d8f6:#2a5491:#237986:#a03b1e:#484d79:#c59820:#b02f30:#9ea7a6:#3f4944:#2a5491:#237986:#a03b1e:#484d79:#c59820:#b02f30:#232c31'"
dset background-color "'#b5d8f6'"
dset foreground-color "'#2a343a'"
dset bold-color "'#2a343a'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
