{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, config, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt-rfc-style;
      };

      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nh
          pkgs.nil
          pkgs.nixfmt-rfc-style
          config.treefmt.build.wrapper
        ];
      };
    };
}
