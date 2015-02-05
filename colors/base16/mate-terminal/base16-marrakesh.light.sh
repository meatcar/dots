#!/usr/bin/env bash
# Base16 Marrakesh - Mate Terminal color scheme install script
# Alexandre Gavioli (http://github.com/Alexx2/)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Marrakesh Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-marrakesh-light"
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
dset palette "'#faf0a5:#c35359:#18974e:#a88339:#477ca1:#8868b3:#75a738:#948e48:#6c6823:#c35359:#18974e:#a88339:#477ca1:#8868b3:#75a738:#201602'"
dset background-color "'#faf0a5'"
dset foreground-color "'#5f5b17'"
dset bold-color "'#5f5b17'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
