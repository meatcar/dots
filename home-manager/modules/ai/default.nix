{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../aider
    ../opencode
    ./peon-ping
  ];
  home.packages = [
    (pkgs.writeShellScriptBin "with-aienv" ''
      source ${config.age.secrets.aienv.path}
      exec "$@"
    '')
    pkgs.uv # for mcps
  ];
  programs.peon-ping.enable = true;
  programs.git.ignores = [
    ".claude/*.local.*"
    "CLAUDE.local.md"
  ];
}
