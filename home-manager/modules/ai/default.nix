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
    ./cli-proxy-api
  ];
  home.packages = [
    (pkgs.writeShellScriptBin "with-aienv" ''
      source ${config.age.secrets.aienv.path}
      exec "$@"
    '')
    pkgs.python3
    pkgs.uv # for mcps
    pkgs.rodney
    pkgs.showboat
    pkgs.sox # for claude /voice
    pkgs.bubblewrap # for codex
    nixpkgs-unstable.openspec
  ];
  services.cli-proxy-api = {
    enable = true;
    environmentFile = config.age.secrets.cliProxyApiEnv.path;
  };
  programs.git.ignores = [
    ".claude/*.local.*"
    "CLAUDE.local.md"
    ".rodney/"
  ];
}
