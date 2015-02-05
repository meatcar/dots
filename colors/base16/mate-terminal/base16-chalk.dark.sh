#!/usr/bin/env bash
# Base16 Chalk - Mate Terminal color scheme install script
# Chris Kempson (http://chriskempson.com)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Chalk Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-chalk-dark"
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
dset palette "'#151515:#fb9fb1:#acc267:#ddb26f:#6fc2ef:#e1a3ee:#12cfc0:#d0d0d0:#505050:#fb9fb1:#acc267:#ddb26f:#6fc2ef:#e1a3ee:#12cfc0:#f5f5f5'"
dset background-color "'#151515'"
dset foreground-color "'#d0d0d0'"
dset bold-color "'#d0d0d0'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
