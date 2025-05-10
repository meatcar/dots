{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = _: {
    treefmt = {
      programs.alejandra.enable = true;
      programs.statix.enable = true;
      programs.deadnix.enable = true;
      programs.shellcheck.enable = true;
    };
  };
}
