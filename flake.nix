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
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
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
    awtrix-pipewire-on-air.url = "github:meatcar/awtrix-pipewire-on-air";
    bw-broker = {
      url = "git+https://ampcode.com/@meatcar/bw-broker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      url = "https://github.com/catppuccin/swaync/releases/download/v1.0.1/catppuccin-mocha.css";
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
            amp-desktop = final.callPackage ./pkgs/amp-desktop { };
            forgemap = final.callPackage ./pkgs/forgemap { };
            helium = final.callPackage ./pkgs/helium { };
            hrd = final.callPackage ./pkgs/hrd { };
            insta360-linux = final.callPackage ./pkgs/insta360-linux { };
            opensessions = final.callPackage ./pkgs/opensessions { };
            parakeet-cpp = final.callPackage ./pkgs/parakeet-cpp { };
            parakeet-transcribe = final.callPackage ./pkgs/parakeet-transcribe { };
            pipewire-control-center = final.callPackage ./pkgs/pipewire-control-center { };
            rodney = final.callPackage ./pkgs/rodney { };
            qe-mac-apid = final.callPackage ./pkgs/qe-mac-apid { };
            weave-merge = final.callPackage ./pkgs/weave { };
          })
        ];
      };
      unstableFor =
        system:
        import (
          if inputs.nixpkgs.lib.hasSuffix "-darwin" system then
            inputs.nixpkgs-unstable-darwin
          else
            inputs.nixpkgs-unstable
        ) ({ inherit system; } // nixpkgsConfig);
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      _module.args = {
        inherit nixpkgsConfig unstableFor;
      };

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        ./flake-modules/devshell.nix
        ./flake-modules/treefmt.nix
        ./flake-modules/checks.nix
        ./flake-modules/nixos.nix
        ./flake-modules/darwin.nix
        ./flake-modules/home.nix
      ];

      perSystem =
        {
          pkgs,
          system,
          lib,
          ...
        }:
        {
          # expose nixpkgs + overlays for CLI use via nix
          # e.g. `nix search . <query>`, `nix run dots#nvim`
          _module.args.pkgs =
            import (if lib.hasSuffix "-darwin" system then inputs.nixpkgs-darwin else inputs.nixpkgs)
              (
                {
                  inherit system;
                }
                // nixpkgsConfig
              );

          legacyPackages = pkgs;
          checks.amp-accounts = pkgs.callPackage ./home-manager/modules/ai/amp/tests.nix { };
          checks.audio-record = pkgs.callPackage ./home-manager/modules/audio-record/tests.nix { };
          checks.parakeet-transcribe = pkgs.callPackage ./pkgs/parakeet-transcribe/tests.nix { };
        };
    };
}
