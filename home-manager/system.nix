{ lib, ... }:
let
  inherit (builtins) getEnv;
in
{
  imports = lib.optionals (getEnv "WSL_DISTRO_NAME" != "") [ ./systems/wsl-singleuser.nix ];

}
