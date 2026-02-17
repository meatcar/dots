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
    ./peon-ping
  ];
  home.packages = [
    (pkgs.writeShellScriptBin "with-aienv" ''
      source ${config.age.secrets.aienv.path}
      exec "$@"
    '')
    pkgs.uv # for mcps
  ];
  services.cli-proxy-api = {
    enable = true;
    environmentFile = config.age.secrets.cliProxyApiEnv.path;
  };
  programs.peon-ping.enable = true;
  programs.git.ignores = [
    ".claude/*.local.*"
    "CLAUDE.local.md"
  ];
}
