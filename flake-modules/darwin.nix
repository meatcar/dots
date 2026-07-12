{
  inputs,
  self,
  nixpkgsConfig,
  ...
}:
let
  mkHost =
    module:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs self;
        llm-agents = inputs.llm-agents.packages.aarch64-darwin;
      };
      modules = [
        module
        # same package surface as the Linux hosts: overlays + allowUnfree
        { nixpkgs = nixpkgsConfig; }
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "denys";
            autoMigrate = true;
          };
        }
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.extraSpecialArgs = {
            inherit inputs;
            llm-agents = inputs.llm-agents.packages.aarch64-darwin;
            # darwin twin of the arg mkSystem passes on Linux
            nixpkgs-unstable = import inputs.nixpkgs-unstable-darwin {
              system = "aarch64-darwin";
              config.allowUnfree = true;
            };
          };
          home-manager.users.denys = import ../home-manager/users/denys.nix;
          home-manager.users.amanda = import ../home-manager/users/amanda.nix;
        }
      ];
    };
in
{
  flake.darwinConfigurations = {
    imogen = mkHost ../systems/imogen;
  };
}
