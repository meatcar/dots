#!/usr/bin/env bash
# Base16 Macintosh - Mate Terminal color scheme install script
# Rebecca Bettencourt (http://www.kreativekorp.com)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Macintosh Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-macintosh-light"
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
dset palette "'#ffffff:#dd0907:#1fb714:#fbf305:#0000d3:#4700a5:#02abea:#c0c0c0:#808080:#dd0907:#1fb714:#fbf305:#0000d3:#4700a5:#02abea:#000000'"
dset background-color "'#ffffff'"
dset foreground-color "'#404040'"
dset bold-color "'#404040'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
