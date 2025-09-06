{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.nixVersions.stable ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.registry = {
    dots.flake = inputs.self;
  };

  programs.nh = {
    enable = true;
    flake = "dots";
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
  };
}
