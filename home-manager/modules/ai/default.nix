{
  config,
  pkgs,
  nixpkgs-unstable,
  llm-agents,
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
    pkgs.codexbar
    pkgs.python3
    pkgs.rodney
    llm-agents.claude-code
    llm-agents.codex
    llm-agents.pi
    llm-agents.showboat
    pkgs.sox # for claude /voice
    pkgs.socat # for sandboxes
    pkgs.bubblewrap # for sandboxes
    pkgs.nono # for sandboxes
    nixpkgs-unstable.openspec
  ];
  services.cli-proxy-api = {
    enable = true;
    environmentFile = config.age.secrets.cliProxyApiEnv.path;
    managerPlus.enable = true;
    piBridge.enable = true;
    settings = {
      quota-exceeded.switch-preview-model = false;
      quota-exceeded.switch-project = true;
      remote-management.allow-remote = true;
      usage-statistics-enabled = true;
    };
  };

  # rodney's bundled (uvx/PyPI) binary has no ROD_CHROME_BIN wrapper; point rod at the
  # nix chromium so `uvx rodney` can launch a Chrome that runs on NixOS.
  home.sessionVariables.ROD_CHROME_BIN = "${pkgs.chromium}/bin/chromium";

  programs.uv = {
    enable = true;
    settings.exclude-newer = "7 days";
  };

  programs.git.ignores = [
    ".pi-*"
    ".claude/*.local.*"
    ".claude/worktrees/"
    ".agents/worktrees/"
    "CLAUDE.local.md"
    ".rodney/"
  ];
}
