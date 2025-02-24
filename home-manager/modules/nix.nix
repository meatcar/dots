{
  pkgs,
  specialArgs,
  ...
}: {
  home.packages = [pkgs.nixVersions.stable];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.registry = {
    nixpkgs.flake = specialArgs.inputs.nixpkgs;
    dots.flake = specialArgs.inputs.self;
  };

  programs.nh = {
    enable = true;
    flake = "dots";
  };
}
