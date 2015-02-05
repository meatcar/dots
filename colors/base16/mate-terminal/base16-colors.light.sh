#!/usr/bin/env bash
# Base16 Colors - Mate Terminal color scheme install script
# mrmrs (http://clrs.cc)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Colors Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-colors-light"
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
dset palette "'#ffffff:#ff4136:#2ecc40:#ffdc00:#0074d9:#b10dc9:#7fdbff:#bbbbbb:#777777:#ff4136:#2ecc40:#ffdc00:#0074d9:#b10dc9:#7fdbff:#111111'"
dset background-color "'#ffffff'"
dset foreground-color "'#555555'"
dset bold-color "'#555555'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
