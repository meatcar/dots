{ config, pkgs, ... }:
{
  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.yml".text = ''
    ${builtins.readFile ./alacritty.yml}
    ${builtins.readFile config.theme.alacritty}
  '';
}
