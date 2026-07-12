# NixOS hosts (x86_64-linux).
{
  inputs,
  nixpkgsConfig,
  unstableFor,
  ...
}:
let
  argsFor = system: {
    inherit inputs;
    nixpkgs-unstable = unstableFor system;
    llm-agents = inputs.llm-agents.packages.${system};
  };
  mkSystem =
    system: extraModules:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = argsFor system;
      inherit system;
      modules = extraModules ++ [
        { nixpkgs = nixpkgsConfig; }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = argsFor system;
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
  flake.nixosConfigurations = {
    watson = mkSystem "x86_64-linux" [
      inputs.agenix.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.impermanence.nixosModules.impermanence
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4
      ../systems/watson
      {
        home-manager.users.meatcar =
          { ... }:
          {
            imports = [
              inputs.agenix.homeManagerModules.default
              inputs.zen-browser.homeModules.default
              inputs.dank-material-shell.homeModules.dank-material-shell
              # inputs.dank-material-shell.homeModules.niri
              ../home-manager/systems/watson
              ../crypt/hm-me.nix
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
}
