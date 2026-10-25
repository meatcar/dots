{
  config,
  lib,
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
    # TODO: drop pi override once llm-agents builds pi with bun >= 1.4.4 (CVE-2026-111497).
    # see https://github.com/numtide/llm-agents.nix/commits/main/flake.lock
    # see https://github.com/NixOS/nixpkgs/pull/574334
    # see https://github.com/NixOS/nixpkgs/pull/577354
    (
      let
        piBun = lib.findFirst (d: lib.getName d == "bun") null llm-agents.pi.nativeBuildInputs;
      in
      if lib.versionOlder (lib.getVersion piBun) "1.4.4" then
        llm-agents.pi.override { inherit (pkgs) bun; }
      else
        llm-agents.pi
    )
    llm-agents.showboat
    pkgs.sox # for claude /voice
    pkgs.socat # for sandboxes
    pkgs.bubblewrap # for sandboxes
    # TODO: use default nodejs once nixos-unstable Node 24 links brotli 1.2.1 (CVE-2026-111497).
    # see https://nixpk.gs/pr-tracker.html?pr=577208
    (nixpkgs-unstable.openspec.override { nodejs = nixpkgs-unstable.nodejs_22; })
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
