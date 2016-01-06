#!/usr/bin/env bash
# Base16 Yesterday Bright - Mate Terminal color scheme install script
# FroZnShiva (https://github.com/FroZnShiva)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Yesterday Bright Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-yesterdaybright-light"
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
dset palette "'#ffffff:#d54e53:#b9ca4a:#e7c547:#7aa6da:#c397d8:#70c0b1:#dfe1e8:#a7adba:#d54e53:#b9ca4a:#e7c547:#7aa6da:#c397d8:#70c0b1:#343d46'"
dset background-color "'#ffffff'"
dset foreground-color "'#65737e'"
dset bold-color "'#65737e'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
