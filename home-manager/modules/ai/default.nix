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
    ./amp
    ./nono
  ];
  home.packages = [
    (pkgs.writeShellScriptBin "with-aienv" ''
      source ${config.age.secrets.aienv.path}
      exec "$@"
    '')
    pkgs.python3
    pkgs.rodney
    llm-agents.claude-code
    llm-agents.codex
    llm-agents.pi
    llm-agents.showboat
    pkgs.sox # for claude /voice
    pkgs.socat # for sandboxes
    pkgs.bubblewrap # for sandboxes
    nixpkgs-unstable.openspec
  ];

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
