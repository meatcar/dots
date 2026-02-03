{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../aider
    ../opencode
  ];
  home.packages = [
    (pkgs.writeShellScriptBin "with-aienv" ''
      source ${config.age.secrets.aienv.path}
      exec "$@"
    '')
  ];
  programs.git.ignores = [
    ".claude/*.local.*"
    "CLAUDE.local.md"
  ];
}
