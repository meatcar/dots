#!/usr/bin/env bash
# Base16 PhD - Mate Terminal color scheme install script
# Hennig Hasemann (http://leetless.de/vim.html)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 PhD Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-phd-light"
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
dset palette "'#ffffff:#d07346:#99bf52:#fbd461:#5299bf:#9989cc:#72b9bf:#b8bbc2:#717885:#d07346:#99bf52:#fbd461:#5299bf:#9989cc:#72b9bf:#061229'"
dset background-color "'#ffffff'"
dset foreground-color "'#4d5666'"
dset bold-color "'#4d5666'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
