{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "dots";
      buildInputs = with pkgs; [
        (import inputs.home-manager {inherit pkgs;}).home-manager
        nixVersions.stable
        git
        (nixos-rebuild.override {nix = nixVersions.stable;})
        stow
        inputs.agenix.packages.${system}.default
      ];
      NIX_PATH = builtins.concatStringsSep ":" [
        "nixpkgs=${inputs.nixpkgs}"
        "home-manager=${inputs.home-manager}"
      ];
      NIXOS_CONFIG = ../configuration.nix;
    };
  };
}
