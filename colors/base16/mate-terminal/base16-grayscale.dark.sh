#!/usr/bin/env bash
# Base16 Grayscale - Mate Terminal color scheme install script
# Alexandre Gavioli (https://github.com/Alexx2/)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Grayscale Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-grayscale-dark"
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
dset palette "'#101010:#7c7c7c:#8e8e8e:#a0a0a0:#686868:#747474:#868686:#b9b9b9:#525252:#7c7c7c:#8e8e8e:#a0a0a0:#686868:#747474:#868686:#f7f7f7'"
dset background-color "'#101010'"
dset foreground-color "'#b9b9b9'"
dset bold-color "'#b9b9b9'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
