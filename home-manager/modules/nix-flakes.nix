{ config, pkgs, ... }:
{
  home.packages = [ pkgs.nixVersions.stable ];

  home.file.nixConf.text = ''
    experimental-features = nix-command flakes
  '';
}
