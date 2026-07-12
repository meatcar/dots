{
  inputs,
  self,
  nixpkgsConfig,
  unstableFor,
  ...
}:
let
  system = "aarch64-darwin";
  specialArgs = {
    inherit inputs self;
    llm-agents = inputs.llm-agents.packages.${system};
  };
  mkHost =
    module:
    inputs.nix-darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [
        module
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
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-bak";
            extraSpecialArgs = specialArgs // {
              nixpkgs-unstable = unstableFor system;
            };
            sharedModules = [ ../home-manager/systems/imogen.nix ];
            users.denys = import ../home-manager/users/denys.nix;
            users.amanda = import ../home-manager/users/amanda.nix;
          };
        }
      ];
    };
in
{
  flake.darwinConfigurations = {
    imogen = mkHost ../systems/imogen;
  };
}
