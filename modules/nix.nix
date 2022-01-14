{ config, pkgs, lib, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  nix = {
    trustedUsers = [ "root" "@wheel" ];
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
    package = lib.mkDefault pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${ lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes" }
    '';
  };
}
