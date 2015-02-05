#!/usr/bin/env bash
# Base16 Summerfruit - Mate Terminal color scheme install script
# Christopher Corley (http://cscorley.github.io/)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Summerfruit Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-summerfruit-dark"
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
dset palette "'#151515:#FF0086:#00C918:#ABA800:#3777E6:#AD00A1:#1faaaa:#D0D0D0:#505050:#FF0086:#00C918:#ABA800:#3777E6:#AD00A1:#1faaaa:#FFFFFF'"
dset background-color "'#151515'"
dset foreground-color "'#D0D0D0'"
dset bold-color "'#D0D0D0'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
