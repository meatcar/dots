{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { inputs', ... }:
    let
      pkgsUnstable = inputs'.nixpkgs-unstable.legacyPackages;
    in
    {
      treefmt = {
        programs.nixfmt.enable = true;
        programs.statix.enable = true;
        programs.deadnix.enable = true;
        programs.actionlint.enable = true;
        programs.oxfmt = {
          enable = true;
          package = pkgsUnstable.oxfmt;
        };
        programs.shfmt.enable = true;
        programs.shellcheck = {
          enable = true;
          excludes = [
            ".envrc"
          ];
        };
      };
    };
}
