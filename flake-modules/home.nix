{
  inputs,
  nixpkgsConfig,
  unstableFor,
  ...
}:
{
  flake.homeConfigurations =
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
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          nixpkgs-unstable = unstableFor system;
        };
        modules = [
          ../home-manager/systems/steamdeck.nix
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
}
