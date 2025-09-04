{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = {
    treefmt = {
      programs.nixfmt.enable = true;
      programs.statix.enable = true;
      programs.deadnix.enable = true;
      programs.actionlint.enable = true;
      programs.shfmt.enable = true;
      programs.shellcheck.enable = true;
      programs.shellcheck.excludes = [
        ".envrc"
      ];
    };
  };
}
