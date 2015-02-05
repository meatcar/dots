#!/usr/bin/env bash
# Base16 Hopscotch - Mate Terminal color scheme install script
# Jan T. Sott

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Hopscotch Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-hopscotch-dark"
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
dset palette "'#322931:#dd464c:#8fc13e:#fdcc59:#1290bf:#c85e7c:#149b93:#b9b5b8:#797379:#dd464c:#8fc13e:#fdcc59:#1290bf:#c85e7c:#149b93:#ffffff'"
dset background-color "'#322931'"
dset foreground-color "'#b9b5b8'"
dset bold-color "'#b9b5b8'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
