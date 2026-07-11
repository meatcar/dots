{ inputs, self, ... }:
let
  mkHost =
    module:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs self; };
      modules = [
        module
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
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.denys = import ../users/denys.nix;
          home-manager.users.amanda = import ../users/amanda.nix;
        }
      ];
    };
in
{
  flake.darwinConfigurations = {
    imogen = mkHost ../hosts/imogen.nix;
  };
}
