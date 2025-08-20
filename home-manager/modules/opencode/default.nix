{
  config,
  pkgs,
  specialArgs,
  ...
}:
let
  uPkgs = specialArgs.nixpkgs-unstable;
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "opencode" ''
      source ${config.age.secrets.aienv.path}
      ${uPkgs.opencode}/bin/opencode "$@"
    '')
  ];
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    # see https://opencode.ai/docs/config/
    autoupdate = false; # managed by nix
  };
  programs.git.ignores = [
    "opencode.json"
  ];
}
