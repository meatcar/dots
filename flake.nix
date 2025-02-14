{
  description = "Nix Development Environment";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://wurzelpfropf.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:yaxitech/ragenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

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
    firefox-arcwtf = {
      url = "github:KiKaraage/ArcWTF";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs: let
    nixpkgsConfig = {
      config = {allowUnfree = true;};
      overlays = [
        inputs.nixpkgs-wayland.overlay
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
        watson = mkSystem [
          inputs.agenix.nixosModules.default
          inputs.disko.nixosModules.disko
          inputs.impermanence.nixosModules.impermanence
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4
          ./systems/watson
          {
            home-manager.users.meatcar = {...}: {
              imports = [
                inputs.agenix.homeManagerModules.default
                inputs.impermanence.homeManagerModules.impermanence
                ./home-manager/systems/watson
              ];
              nixpkgs.config = nixpkgsConfig;
              home.stateVersion = "24.11";
            };
          }
        ];
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
        iso = mkSystem [
          {system.stateVersion = "24.11";}
          ({
            pkgs,
            modulesPath,
            ...
          }: {
            imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
            environment.systemPackages = [pkgs.neovim];
            isoImage.forceTextMode = true;
          })
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
