{ config, lib, pkgs, ... }:
{
  home.sessionVariables = config.home.sessionVariables // { XDG_RUNTIME_DIR = "$HOME/.cache/runtime"; };

  home.packages = builtins.attrValues {
    inherit (pkgs) keybase kbfs;
  };
}
