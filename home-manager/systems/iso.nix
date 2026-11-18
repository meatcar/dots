{ pkgs, ... }:
{
  imports = [
    ./cli.nix
    ../modules/git/lazygit.nix
    ../modules/jujutsu/jjui.nix
    ../modules/television
  ];

  home.packages = with pkgs; [
    delta
    jujutsu
  ];

  home.stateVersion = "26.05";
}
