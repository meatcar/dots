{
  description = "Nix Development Environment";

  inputs =
    {
      flake-utils.url = "github:numtide/flake-utils";
      # TODO: locking temporarily until https://github.com/NixOS/nixpkgs/issues/205733 is in nixos-unstable
      # see: https://nixpk.gs/pr-tracker.html?pr=205803
      nixpkgs.url = "github:nixos/nixpkgs/2787fc7d1e51404678614bf0fe92fc296746eec0";
      # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
      nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
      neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
      neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
      emacs-overlay.url = "github:nix-community/emacs-overlay";
      emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
      declarative-cachix.url = "github:jonascarpay/declarative-cachix";
      nixos-wsl.url = "github:nix-community/NixOS-WSL";
      nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

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
      fish-docker-compose = {
        url = "github:brgmnn/fish-docker-compose";
        flake = false;
      };
      nnn = {
        url = "github:jarun/nnn";
        flake = false;
      };
      vscode-server = {
        url = "github:msteen/nixos-vscode-server";
        flake = false;
      };
      autopair-fish = {
        url = "github:jorgebucaran/autopair.fish";
        flake = false;
      };
    };


  outputs = { self, ... }@inputs:
    let
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = [
          inputs.nixpkgs-wayland.overlay
          inputs.neovim-nightly-overlay.overlay
          inputs.emacs-overlay.overlay
        ];
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
                nixVersions.stable
                git
                (nixos-rebuild.override { nix = nixVersions.stable; })
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
              { system.stateVersion = "21.11"; }
              ./systems/wsl-nixos
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.meatcar = { ... }: {
                  imports = [
                    ./home-manager/systems/wsl-nixos.nix
                  ];
                  home.stateVersion = "21.11";
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
