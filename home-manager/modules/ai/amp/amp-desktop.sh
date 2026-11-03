#!/bin/sh
set -eu

account=@account@

config_home=${XDG_CONFIG_HOME:-$HOME/.config}
data_home=${XDG_DATA_HOME:-$HOME/.local/share}
root=$data_home/amp-accounts/$account/desktop

(
  umask 077
  mkdir -p "$root" "$config_home/amp-desktop"
)

exec bwrap --bind / / \
  --dev-bind /dev /dev \
  --bind "$root" "$(realpath -e "$config_home/amp-desktop")" \
  --ro-bind @asar@ @app@/resources/app.asar \
  -- @amp-desktop@ "$@"
