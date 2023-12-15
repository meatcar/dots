{ config, pkgs, ... }:
{
  home.packages = [ pkgs.nixVersions.stable ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
