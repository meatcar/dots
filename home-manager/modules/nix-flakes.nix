{ config, pkgs, ... }:
{
  home.packages = [ pkgs.nixFlakes ];

  home.file.nixConf.text = ''
    experimental-features = nix-command flakes
  '';
}
