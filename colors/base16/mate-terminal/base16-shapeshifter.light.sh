#!/usr/bin/env bash
# Base16 shapeshifter - Mate Terminal color scheme install script
# Tyler Benziger (http://tybenz.com)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 shapeshifter Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-shapeshifter-light"
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
dset palette "'#f9f9f9:#e92f2f:#0ed839:#dddd13:#3b48e3:#f996e2:#23edda:#ababab:#343434:#e92f2f:#0ed839:#dddd13:#3b48e3:#f996e2:#23edda:#000000'"
dset background-color "'#f9f9f9'"
dset foreground-color "'#102015'"
dset bold-color "'#102015'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
