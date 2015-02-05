#!/usr/bin/env bash
# Base16 Google - Mate Terminal color scheme install script
# Seth Wright (http://sethawright.com)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Google Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-google-dark"
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
dset palette "'#1d1f21:#CC342B:#198844:#FBA922:#3971ED:#A36AC7:#3971ED:#c5c8c6:#969896:#CC342B:#198844:#FBA922:#3971ED:#A36AC7:#3971ED:#ffffff'"
dset background-color "'#1d1f21'"
dset foreground-color "'#c5c8c6'"
dset bold-color "'#c5c8c6'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
