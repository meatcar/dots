{
  description = "Nix Development Environment";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://ghostty.cachix.org"
      "https://cache.numtide.com" # llm-agents.nix
      "https://nyx-cache.chaotic.cx" # chaotic (cachyos kernel)
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ghostty.cachix.org:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
    ];
  };

  inputs = {
    # flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    # rest
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
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
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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
    dank-greeter = {
      url = "github:duxlabs-dev/dux-greeter/v2.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nyxpkgs-unstable only advances once its builds are cached; no follows, or the cache misses
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    handy = {
      url = "github:cjpais/Handy";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    oyui = {
      url = "github:emilien-jegou/oyui";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    figma-linux-next = {
      url = "github:arximus88/figma-linux-next/dev";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    amp-completions = {
      url = "github:meatcar/amp-completions";
      flake = false;
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix"; # no inputs to follow
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.8.0"; # no inputs to follow
    paseo = {
      url = "github:getpaseo/paseo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awtrix-pipewire-on-air.url = "github:meatcar/awtrix-pipewire-on-air";

    plug-kak = {
      url = "github:andreyorst/plug.kak";
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
          (import ./overlays/bun-cve-2026-111497.nix)
          (final: _prev: {
            figma-console-mcp = final.callPackage ./pkgs/figma-console-mcp { };
            amp-desktop = final.callPackage ./pkgs/amp-desktop { };
            forgemap = final.callPackage ./pkgs/forgemap { };
            helium = final.callPackage ./pkgs/helium { };
            hrd = final.callPackage ./pkgs/hrd { };
            insta360-linux = final.callPackage ./pkgs/insta360-linux { };
            opensessions = final.callPackage ./pkgs/opensessions { };
            pipewire-control-center = final.callPackage ./pkgs/pipewire-control-center { };
            rodney = final.callPackage ./pkgs/rodney { };
            qe-mac-apid = final.callPackage ./pkgs/qe-mac-apid { };
            weave-merge = final.callPackage ./pkgs/weave { };
          })
        ];
      };
      specialArgs = {
        inherit inputs;
        # upstream-built packages, served by cache.numtide.com
        llm-agents = inputs.llm-agents.packages.x86_64-linux;
      };
      extraSpecialArgs = specialArgs;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./flake-modules/devshell.nix
        ./flake-modules/treefmt.nix
        ./flake-modules/checks.nix
      ];

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          # expose nixpkgs + overlays for CLI use via nix
          # e.g. `nix search . <query>`, `nix run dots#nvim`
          _module.args.pkgs = import inputs.nixpkgs (
            {
              inherit system;
            }
            // nixpkgsConfig
          );

          legacyPackages = pkgs;
          checks.amp-accounts = pkgs.callPackage ./home-manager/modules/ai/amp/tests.nix { };
          checks.audio-record = pkgs.callPackage ./home-manager/modules/audio-record/tests.nix { };
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
                      # Don't hard-fail activation when a runtime-replaced file
                      # (e.g. GTK rewriting recently-used.xbel over its managed
                      # symlink, impermanence#107) is in the way; back it up to
                      # <file>.hm-bak and relink instead.
                      backupFileExtension = "hm-bak";
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
                      ./crypt/hm-me.nix
                    ];
                    nixpkgs = nixpkgsConfig;
                    home.stateVersion = "26.05";
                  };
              }
            ];
            iso = mkSystem "x86_64-linux" [
              {
                system.stateVersion = "26.05";
                boot.zfs.forceImportRoot = false;
              }
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
            nixpkgs-unstable = import inputs.nixpkgs-unstable (
              {
                inherit system;
              }
              // nixpkgsConfig
            );
          in
          {
            deck = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = extraSpecialArgs // {
                inherit nixpkgs-unstable;
              };
              modules = [
                ./home-manager/systems/steamdeck.nix
                {
                  nixpkgs.config = nixpkgsConfig.config;
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
