#!/usr/bin/env bash
# Base16 harmonic16 - Mate Terminal color scheme install script
# Jannik Siebert (https://github.com/janniks)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 harmonic16 Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-harmonic16-dark"
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
dset palette "'#0b1c2c:#bf8b56:#56bf8b:#8bbf56:#8b56bf:#bf568b:#568bbf:#cbd6e2:#627e99:#bf8b56:#56bf8b:#8bbf56:#8b56bf:#bf568b:#568bbf:#f7f9fb'"
dset background-color "'#0b1c2c'"
dset foreground-color "'#cbd6e2'"
dset bold-color "'#cbd6e2'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
