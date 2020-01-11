let
  sources = import ./nix/sources.nix;
in
[
  "nixpkgs=${sources.nixpkgs}"
  "home-manager=${sources.home-manager}"
  "nixos-config=/etc/nixos/configuration.nix"
]
