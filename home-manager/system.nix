{ lib, ... }:
let
  inherit (builtins) getEnv stringLength;
  conditionalPaths = condition: paths: if condition then paths else [];
in
{
  imports = lib.flatten [
    (conditionalPaths (getEnv "WSL_DISTRO_NAME" != "") [ ./systems/wsl.nix ])
  ];
}
