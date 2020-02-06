{ config, pkgs, ... }:
{
  home.packages = [ pkgs.direnv ];
  home.file.".direnvrc".source = ./direnvrc;
  programs.git.ignores = [ ".direnv/" ];
}
