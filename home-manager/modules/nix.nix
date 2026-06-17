{
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = [ pkgs.nixVersions.stable ];

  nix.extraOptions = ''
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
