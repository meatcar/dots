{ pkgs, ... }:
{
  home.packages = [ pkgs.jiratui ];

  programs.fish.completions.jiratui.body = ''
    ${pkgs.jiratui}/bin/jiratui completions fish | source
  '';
}
