{
  description = "Nix Development Environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    # zellij.url = "github:a-kenji/zellij-nix";

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
    # fish
    fish-ssh-agent = {
      url = "github:danhper/fish-ssh-agent";
      flake = false;
    };
    fish-docker-compose = {
      url = "github:brgmnn/fish-docker-compose";
      flake = false;
    };
    vscode-fish = {
      url = "github:kidonng/vscode.fish";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs: let
    nixpkgsConfig = {
      config = {allowUnfree = true;};
      overlays = [
        inputs.nixpkgs-wayland.overlay
        inputs.neovim-nightly-overlay.overlays.default
        inputs.emacs-overlay.overlay
      ];
    };
    specialArgs = {inherit inputs;};
  in (
    inputs.flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import inputs.nixpkgs (nixpkgsConfig // {inherit system;});
    in {
      # expose the system nixpkgs for searching, shells
      # run 'nix registry add dots /path/to/repo`
      # then you can search like `nix search dots <query>`
      legacyPackages = pkgs;

      devShell = pkgs.mkShell rec {
        name = "dots";

        buildInputs = with pkgs; [
          (import inputs.home-manager {inherit pkgs;}).home-manager
          nixVersions.stable
          git
          (nixos-rebuild.override {nix = nixVersions.stable;})
          stow
        ];
        NIX_PATH = builtins.concatStringsSep ":" [
          "nixpkgs=${inputs.nixpkgs}"
          "home-manager=${inputs.home-manager}"
        ];
        NIXOS_CONFIG = ./configuration.nix;
      };
    })
    // {
      nixosConfigurations = let
        mkSystem = extraModules: (
          inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";
            modules =
              extraModules
              ++ [
                {nixpkgs = nixpkgsConfig;}
                inputs.home-manager.nixosModules.home-manager
                {home-manager.extraSpecialArgs = specialArgs;}
              ];
          }
        );
      in {
        tormund = mkSystem [./systems/tormund];
        nixos = mkSystem [
          {system.stateVersion = "23.05";}
          ./systems/wsl-nixos
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.meatcar = {...}: {
              imports = [
                ./home-manager/systems/wsl-nixos.nix
              ];
              home.stateVersion = "23.05";
            };
          }
        ];
      };
      homeConfigurations = let
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs ({
            inherit system;
          }
          // nixpkgsConfig);
      in {
        meatcar = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [
            ./home-manager/systems/wsl-singleuser.nix
            {
              nixpkgs = nixpkgsConfig;
              home = rec {
                username = "meatcar";
                homeDirectory = "/home/${username}";
                stateVersion = "20.09";
              };
            }
          ];
        };
        deck = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [
            ./home-manager/systems/steamdeck.nix
            {
              nixpkgs = nixpkgsConfig;
              home = rec {
                username = "deck";
                homeDirectory = "/home/${username}";
                stateVersion = "23.05";
              };
            }
          ];
        };
      };
    }
  );
}
