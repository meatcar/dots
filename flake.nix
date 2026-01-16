{
  description = "Nix Development Environment";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://wurzelpfropf.cachix.org" # ragenix
      "https://ghostty.cachix.org"
      "https://attic.xuyh0120.win/lantian" # nix-cachyos-kernel
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "wurzelpfropf.cachix.org:ilZwK5a6wJqVr7Fyrzp4blIEkGK+LJT0QrpWr1qBNq0="
      "ghostty.cachix.org:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  inputs = {
    # flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    # rest
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix = {
      # secrets
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      # disk mgmt
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      # secure boot mgmt
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hardware incantations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:YaLTeR/niri/v25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
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
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-delta = {
      url = "github:catppuccin/delta";
      flake = false;
    };
    catppuccin-swaync = {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.2.3/mocha.css";
      flake = false;
    };
    tinted-jjui = {
      url = "github:vic/tinted-jjui";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          # inputs.niri.overlays.default
          inputs.nix-cachyos-kernel.overlays.pinned
        ];
      };
      specialArgs = { inherit inputs; };
      extraSpecialArgs = specialArgs;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./flake-modules/devshell.nix
        ./flake-modules/treefmt.nix
        ./flake-modules/git-hooks.nix
      ];

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          # expose the system nixpkgs for searching, shells
          # run 'nix registry add dots /path/to/repo`
          # then you can search like `nix search dots <query>`
          _module.args.pkgs = import inputs.nixpkgs (
            {
              inherit system;
            }
            // nixpkgsConfig
          );

          legacyPackages = pkgs;
        };

      flake = {
        nixosConfigurations =
          let
            mkSystem =
              system: extraModules:
              let
                nixpkgs-unstable = import inputs.nixpkgs-unstable (
                  {
                    inherit system;
                  }
                  // nixpkgsConfig
                );
              in
              inputs.nixpkgs.lib.nixosSystem {
                specialArgs = specialArgs // {
                  inherit nixpkgs-unstable;
                };
                system = "x86_64-linux";
                modules = extraModules ++ [
                  { nixpkgs = nixpkgsConfig; }
                  inputs.home-manager.nixosModules.home-manager
                  {
                    home-manager = {
                      extraSpecialArgs = extraSpecialArgs // {
                        inherit nixpkgs-unstable;
                      };
                    };
                  }
                ];
              };
          in
          {
            watson = mkSystem "x86_64-linux" [
              inputs.agenix.nixosModules.default
              inputs.disko.nixosModules.disko
              inputs.impermanence.nixosModules.impermanence
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4
              ./systems/watson
              {
                home-manager.users.meatcar =
                  { ... }:
                  {
                    imports = [
                      inputs.agenix.homeManagerModules.default
                      inputs.zen-browser.homeModules.default
                      inputs.dank-material-shell.homeModules.dank-material-shell
                      # inputs.dank-material-shell.homeModules.niri
                      ./home-manager/systems/watson
                      ./git-crypt/hm-me.nix
                    ];
                    nixpkgs.config = nixpkgsConfig;
                    home.stateVersion = "25.11";
                  };
              }
            ];
            iso = mkSystem "x86_64-linux" [
              { system.stateVersion = "25.11"; }
              (
                {
                  pkgs,
                  modulesPath,
                  ...
                }:
                {
                  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
                  environment.systemPackages = [ pkgs.neovim ];
                  isoImage.forceTextMode = true;
                }
              )
            ];
          };

        homeConfigurations =
          let
            system = "x86_64-linux";
            pkgs = import inputs.nixpkgs (
              {
                inherit system;
              }
              // nixpkgsConfig
            );
          in
          {
            deck = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs extraSpecialArgs;
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
      };
    };
}
