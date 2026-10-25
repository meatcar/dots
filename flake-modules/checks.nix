_: {
  perSystem =
    { pkgs, inputs', ... }:
    {
      checks = {
        bun-brotli = pkgs.runCommand "bun-brotli" { } ''
          ${pkgs.bun}/bin/bun ${../scripts/tests/brotli-invalid-input.cjs}
          touch $out
        '';
        node22-brotli = pkgs.runCommand "node22-brotli" { } ''
          ${pkgs.nodejs_22}/bin/node ${../scripts/tests/brotli-invalid-input.cjs}
          touch $out
        '';
        node22-unstable-brotli = pkgs.runCommand "node22-unstable-brotli" { } ''
          ${inputs'.nixpkgs-unstable.legacyPackages.nodejs_22}/bin/node ${../scripts/tests/brotli-invalid-input.cjs}
          touch $out
        '';
      };
    };
}
