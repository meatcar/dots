#!/usr/bin/env bash
# Base16 Solarized - Mate Terminal color scheme install script
# Ethan Schoonover (http://ethanschoonover.com/solarized)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Solarized Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-solarized-light"
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
dset palette "'#fdf6e3:#dc322f:#859900:#b58900:#268bd2:#6c71c4:#2aa198:#93a1a1:#657b83:#dc322f:#859900:#b58900:#268bd2:#6c71c4:#2aa198:#002b36'"
dset background-color "'#fdf6e3'"
dset foreground-color "'#586e75'"
dset bold-color "'#586e75'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
