{ config, lib, pkgs, ... }:
{
  home.sessionVariables = { XDG_RUNTIME_DIR = "$HOME/.cache/runtime"; };

  nixpkgs.overlays = [ (import ../../overlays/wsl-open.nix) ];

  home.packages = builtins.attrValues {
    inherit (pkgs) keybase kbfs wsl-open;
  };

  xdg.configFile."fish/fishfile".text = ''
    # WSL Only:
    danhper/fish-ssh-agent
  '';


}
