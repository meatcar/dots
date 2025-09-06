{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  imports = [
    ../aider
    ../opencode
  ];
  home.packages = [
    nixpkgs-unstable.amp-cli
    (pkgs.writeShellScriptBin "with-aienv" ''
      source ${config.age.secrets.aienv.path}
      "$@"
    '')
  ];
}
