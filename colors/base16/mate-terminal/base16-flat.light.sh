#!/usr/bin/env bash
# Base16 Flat - Mate Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Flat Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-flat-light"
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
dset palette "'#ECF0F1:#E74C3C:#2ECC71:#F1C40F:#3498DB:#9B59B6:#1ABC9C:#e0e0e0:#95A5A6:#E74C3C:#2ECC71:#F1C40F:#3498DB:#9B59B6:#1ABC9C:#2C3E50'"
dset background-color "'#ECF0F1'"
dset foreground-color "'#7F8C8D'"
dset bold-color "'#7F8C8D'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
