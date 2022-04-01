{
  description = "Nix Development Environment";

  inputs =
    {
      flake-utils.url = "github:numtide/flake-utils";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
      nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
      neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
      neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
      emacs-overlay.url = "github:nix-community/emacs-overlay";
      emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
      declarative-cachix.url = "github:jonascarpay/declarative-cachix";
      declarative-cachix.inputs.nixpkgs.follows = "nixpkgs";

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
      fzf-fish = {
        url = "github:PatrickF1/fzf.fish";
        flake = false;
      };
      z = {
        url = "github:jethrokuan/z";
        flake = false;
      };
      fish-docker-compose = {
        url = "github:brgmnn/fish-docker-compose";
        flake = false;
      };
      nnn = {
        url = "github:jarun/nnn";
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
          let
            pkgs = import inputs.nixpkgs (nixpkgsConfig // { inherit system; });
          in
          {
            # expose the system nixpkgs for searching, shells
            # run 'nix registry add dots /path/to/repo`
            # then you can search like `nix search dots <query>`
            legacyPackages = pkgs;

            devShell = pkgs.mkShell rec {

              name = "dots";

              buildInputs = with pkgs; [
                (import inputs.home-manager { inherit pkgs; }).home-manager
                nixFlakes
                git
                (nixos-rebuild.override { nix = nixFlakes; })
                stow
              ];
              NIX_PATH = builtins.concatStringsSep ":" [
                "nixpkgs=${inputs.nixpkgs}"
                "home-manager=${inputs.home-manager}"
              ];
              NIXOS_CONFIG = ./configuration.nix;
            };
          })
      //
      {
        nixosConfigurations =
          let
            mkSystem = extraModules: (
              inputs.nixpkgs.lib.nixosSystem {
                inherit specialArgs;
                system = "x86_64-linux";
                modules = extraModules ++ [
                  { nixpkgs = nixpkgsConfig; }
                  inputs.home-manager.nixosModules.home-manager
                  { home-manager.extraSpecialArgs = specialArgs; }
                ];
              });
          in
          {
            tormund = mkSystem [ ./systems/tormund ];
            nixos = mkSystem [
              ./systems/wsl-nixos
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.meatcar = { ... }: {
                  imports = [
                    ./home-manager/systems/common.nix
                    ./home-manager/modules/keychain.nix
                    ./home-manager/modules/gtk.nix
                  ];
                  home.stateVersion = "21.05";
                };
              }
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
              home.stateVersion = "20.09";
            };
          };
        };
      }
    );

}
