{ config, pkgs, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };
  documentation.dev.enable = true;

  nix = {
    nixPath = import ../nix-path.nix;
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };
  };
}
