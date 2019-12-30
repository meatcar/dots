{ config, lib, pkgs, ... }:
{
  home.sessionVariables = { XDG_RUNTIME_DIR = "$HOME/.cache/runtime"; };

  home.packages = builtins.attrValues {
    inherit (pkgs) keybase kbfs;
  };

  xdg.configFile."fish/fishfile".text = ''
    # WSL Only:
    danhper/fish-ssh-agent
  '';
}
