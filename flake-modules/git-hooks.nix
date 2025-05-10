{ inputs, ... }:
{
  imports = [ inputs.git-hooks-nix.flakeModule ];
  perSystem =
    { config, ... }:
    let
      cfg = config.pre-commit.settings;
    in
    {
      pre-commit.settings.hooks = {
        treefmt.enable = true;
        commitizen.enable = true;
        flake-checker.enable = true;
        flake-checker.entry = "${cfg.hooks.flake-checker.package}/bin/flake-checker -f --no-telemetry";
      };
    };
}
