{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  home.packages = [
    (pkgs.writeShellScriptBin "opencode" ''
      source ${config.age.secrets.aienv.path}
      ${nixpkgs-unstable.opencode}/bin/opencode "$@"
    '')
  ];
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    # see https://opencode.ai/docs/config/
    autoupdate = false; # managed by nix
    instructions = [
      "CONTRIBUTING.md"
      "docs/guidelines.md"
      ".rules"
      ".cursor/rules/*.md"
    ];
    permission = {
      bash = "ask";
      edit = "allow";
      webfetch = "allow";
    };
  };
  programs.git.ignores = [
    "opencode.json"
  ];
}
