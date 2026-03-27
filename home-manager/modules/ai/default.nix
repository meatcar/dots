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
    pkgs.rodney
    pkgs.showboat
    pkgs.sox # for claude /voice
    pkgs.socat # for sandboxes
    pkgs.bubblewrap # for sandboxes
    nixpkgs-unstable.openspec
  ];
  services.cli-proxy-api = {
    enable = true;
    environmentFile = config.age.secrets.cliProxyApiEnv.path;
  };

  programs.uv = {
    enable = true;
    settings.exclude-newer = "7 days";
  };

  programs.git.ignores = [
    ".claude/*.local.*"
    ".claude/worktrees/"
    "CLAUDE.local.md"
    ".rodney/"
  ];
}
