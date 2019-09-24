{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ./config.fish;
  };

  xdg.configFile."fish/fishfile".source = ./fishfile;
  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };

  home.packages = [
    pkgs.fzf
    pkgs.bat
  ];
}
