{
  description = "Nix Development Environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, flake-utils, nixpkgs, home-manager }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          config = { allowUnfree = true; };
        };
      in
      {
        devShell = pkgs.mkShell rec {

          name = "home-manager-template-shell";

          buildInputs = with pkgs; [
            (import home-manager { inherit pkgs; }).home-manager
          ];
          NIX_PATH = builtins.concatStringsSep ":" [
            "nixpkgs=${nixpkgs}"
            "home-manager=${home-manager}"
          ];

          shellHook = ''
            export HOME_MANAGER_CONFIG="./home.nix"
          '';
        };
      });

}


