#!/usr/bin/env bash
# Base16 Darktooth - Mate Terminal color scheme install script
# Jason Milkins (https://github.com/jasonm23)

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Darktooth Light"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-darktooth-light"
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
dset palette "'#FDF4C1:#FB543F:#95C085:#FAC03B:#0D6678:#8F4673:#8BA59B:#A89984:#665C54:#FB543F:#95C085:#FAC03B:#0D6678:#8F4673:#8BA59B:#1D2021'"
dset background-color "'#FDF4C1'"
dset foreground-color "'#504945'"
dset bold-color "'#504945'"
dset bold-color-same-as-fg "true"
dset use-theme-colors "false"
dset use-theme-background "false"
