{
  inputs,
  pkgs,
  llm-agents,
  ...
}:
let
  # TODO: drop bun-bin override once llm-agents bun-bin is >= 1.4.4 (CVE-2026-111497).
  # see https://github.com/numtide/llm-agents.nix/commits/main/packages/bun-bin
  bunBinTarget = "bun-linux-x64-baseline-v1.4.4";
  bun-bin = llm-agents.bun-bin.overrideAttrs (old: {
    version = "1.4.4";
    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.4/bun-linux-x64-baseline.zip";
      hash = "sha256-4ERutVmVdy65iUvrrppr42jZhai5Jx7hJEhvmUbu3XY=";
    };
    installPhase = ''
      runHook preInstall
      install -Dm755 bun $out/share/bun-bin/${bunBinTarget}
      runHook postInstall
    '';
    passthru = old.passthru // {
      target = bunBinTarget;
    };
  });
in
{
  imports = [ inputs.hunk.homeManagerModules.default ];

  # same release as the hunk flake, but prebuilt (cache.numtide.com)
  programs.hunk.package =
    if pkgs.lib.versionOlder llm-agents.bun-bin.version "1.4.4" then
      llm-agents.hunk.override { inherit bun-bin; }
    else
      llm-agents.hunk;

  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      theme = "auto";
      mode = "auto";
      line_numbers = false;
      wrap_lines = true;
      agent_notes = true;
    };
  };
}
