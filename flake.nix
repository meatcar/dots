{
  description = "Nix Development Environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    plug-kak = {
      url = "github:andreyorst/plug.kak";
      flake = false;
    };
    alacritty-theme = {
      url = "github:eendroroy/alacritty-theme";
      flake = false;
    };
    wsl-open = {
      url = "gitlab:4U6U57/wsl-open";
      flake = false;
    };
  };


  outputs = { self, ... }@inputs:
    let
      overlays = [
        inputs.nixpkgs-wayland.overlay
        inputs.neovim-nightly-overlay.overlay
        inputs.emacs-overlay.overlay
      ];
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = overlays;
      };
      specialArgs = { inherit inputs; };
    in
    (
      inputs.flake-utils.lib.eachDefaultSystem
        (system:
          let pkgs = inputs.nixpkgs.legacyPackages.${system}; in
          {

            devShell = pkgs.mkShell rec {

              name = "dots";

              buildInputs = with pkgs; [
                (import inputs.home-manager { inherit pkgs; }).home-manager
                nixFlakes
                (nixos-rebuild.override { nix = nixFlakes; })
                stow
                (pkgs.writeShellScriptBin "nixos-rebuild-pretty" ''
                  # prettier than nixos-rebuild switch
                  sudo -E sh -c "nix build --no-link -f '<nixpkgs/nixos>' config.system.build.toplevel && nixos-rebuild $@"
                '')
              ];
              NIX_PATH = builtins.concatStringsSep ":" [
                "nixpkgs=${inputs.nixpkgs}"
                "home-manager=${inputs.home-manager}"
              ];
            };
          })
      //
      {
        nixosConfigurations.tormund = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = specialArgs;
          modules = [
            { nixpkgs = nixpkgsConfig; }
            inputs.home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./configuration.nix
          ];
        };
        homeConfigurations = {
          meatcar = inputs.home-manager.lib.homeManagerConfiguration rec {
            system = "x86_64-linux";
            username = "meatcar";
            homeDirectory = "/home/${username}";
            extraSpecialArgs = specialArgs;
            configuration = { ... }: {
              imports = [ ./home.nix ];
              nixpkgs = nixpkgsConfig;
            };
          };
        };
        templates = {
          project = {
            path = ./templates/project;
            description = "A basic dev environment with direnv and nix";
          };
          defaultTemplate = self.templates.project;
        };
      }
    );

}
