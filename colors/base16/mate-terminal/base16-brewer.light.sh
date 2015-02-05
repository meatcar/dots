#!/usr/bin/env bash
# Base16 Brewer - Mate Terminal color scheme install script
# Timothée Poisot (http://github.com/tpoisot)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Brewer Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-brewer-light"
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
dset palette "'#fcfdfe:#e31a1c:#31a354:#dca060:#3182bd:#756bb1:#80b1d3:#b7b8b9:#737475:#e31a1c:#31a354:#dca060:#3182bd:#756bb1:#80b1d3:#0c0d0e'"
dset background-color "'#fcfdfe'"
dset foreground-color "'#515253'"
dset bold-color "'#515253'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
