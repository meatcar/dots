{ config, pkgs, ... }:
let
  # previews in README.
  alacritty-themes = config.sources.alacritty-theme;
  # previews: http://chriskempson.com/projects/base16/
  base16-themes = config.sources.base16-alacritty;
  theme = {
    light = "${base16-themes}/colors/base16-summerfruit-light-256.yml";
    dark = "${base16-themes}/colors/base16-material-palenight-256.yml";
  };
in
{
  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.yml".text = ''
    ${builtins.readFile ./alacritty.yml}
    ${builtins.readFile theme.dark}
  '';
}
