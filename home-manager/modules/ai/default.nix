{
  config,
  pkgs,
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
