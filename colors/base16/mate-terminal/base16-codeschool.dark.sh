#!/usr/bin/env bash
# Base16 Codeschool - Mate Terminal color scheme install script
# brettof86

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Codeschool Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-codeschool-dark"
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
dset palette "'#232c31:#2a5491:#237986:#a03b1e:#484d79:#c59820:#b02f30:#9ea7a6:#3f4944:#2a5491:#237986:#a03b1e:#484d79:#c59820:#b02f30:#b5d8f6'"
dset background-color "'#232c31'"
dset foreground-color "'#9ea7a6'"
dset bold-color "'#9ea7a6'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
