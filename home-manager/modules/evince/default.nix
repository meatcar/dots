{ pkgs, ... }:
{
  home.packages = [
    pkgs.evince
    pkgs.papers
  ];
}
