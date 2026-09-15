#!/bin/sh
set -eu

account=@account@

config_home=${XDG_CONFIG_HOME:-$HOME/.config}
data_home=${XDG_DATA_HOME:-$HOME/.local/share}
cache_home=${XDG_CACHE_HOME:-$HOME/.cache}
state_home=${XDG_STATE_HOME:-$HOME/.local/state}
root=$data_home/amp-accounts/$account

(
  umask 077
  mkdir -p "$root/config" "$root/data" "$root/cache" "$root/state" "$root/home"
  mkdir -p "$config_home/amp" "$data_home/amp" "$cache_home/amp" "$state_home/amp" "$HOME/.amp"
)

exec bwrap --bind / / \
  --dev-bind /dev /dev \
  --bind "$root/config" "$(realpath -e "$config_home/amp")" \
  --bind "$root/data" "$(realpath -e "$data_home/amp")" \
  --bind "$root/cache" "$(realpath -e "$cache_home/amp")" \
  --bind "$root/state" "$(realpath -e "$state_home/amp")" \
  --bind "$root/home" "$(realpath -e "$HOME/.amp")" \
  --unsetenv AMP_API_KEY \
  --unsetenv AMP_SETTINGS_FILE \
  --unsetenv AMP_LOG_FILE \
  --chdir "$PWD" \
  -- @amp@ "$@"
