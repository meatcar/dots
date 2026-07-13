{
  pkgs,
  inputs,
  config,
  lib,
  options,
  ...
}:
{
  home.packages = [ pkgs.nixVersions.stable ];

  # hosts without agenix (e.g. deck) get no access-tokens include
  nix.extraOptions = lib.optionalString (options ? age && config.age.secrets ? nixConfAccessTokens) ''
    !include ${config.age.secrets.nixConfAccessTokens.path}
  '';

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.registry = {
    dots.flake = inputs.self;
    pkgs.flake = inputs.nixpkgs-unstable;
  };

  programs.nh = {
    enable = true;
    flake = "dots";
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
  };
}
