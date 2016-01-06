#!/usr/bin/env bash
# Base16 Yesterday Night - Mate Terminal color scheme install script
# FroZnShiva (https://github.com/FroZnShiva)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Yesterday Night Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-yesterdaynight-dark"
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
dset palette "'#343d46:#cc6666:#b5bd68:#f0c674:#81a2be:#b294bb:#8abeb7:#dfe1e8:#a7adba:#cc6666:#b5bd68:#f0c674:#81a2be:#b294bb:#8abeb7:#ffffff'"
dset background-color "'#343d46'"
dset foreground-color "'#dfe1e8'"
dset bold-color "'#dfe1e8'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
