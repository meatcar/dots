#!/usr/bin/env bash
# Base16 Twilight - Mate Terminal color scheme install script
# David Hart (http://hart-dev.com)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Twilight Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-twilight-dark"
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
dset palette "'#1e1e1e:#cf6a4c:#8f9d6a:#f9ee98:#7587a6:#9b859d:#afc4db:#a7a7a7:#5f5a60:#cf6a4c:#8f9d6a:#f9ee98:#7587a6:#9b859d:#afc4db:#ffffff'"
dset background-color "'#1e1e1e'"
dset foreground-color "'#a7a7a7'"
dset bold-color "'#a7a7a7'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
