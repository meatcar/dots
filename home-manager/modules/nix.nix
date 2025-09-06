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
    nixpkgs.flake = inputs.nixpkgs;
    dots.flake = inputs.self;
  };

  programs.nh = {
    enable = true;
    flake = "dots";
  };
}
