# Brew upgrades the casks, so turn off app self-updaters wherever a per-user
# switch exists. Machine-wide policies live in
# modules/darwin/homebrew/no-self-update.nix.
# NOTE: no known switch: Chrome (needs MDM), 1Password and Claude (need a
# configuration profile), Docker (needs Business), GitHub Desktop, GitFiend,
# Mailspring, Raycast, Warp, WhatsApp.
{ lib, pkgs, ... }:
let
  sparkleApps = [
    "com.ampcode.amp.macos"
    "com.cmuxterm.app"
    "com.mitchellh.ghostty"
    "com.openai.codex"
    "com.sproutcube.Shortcat"
    "com.torusknot.SourceTreeNotMAS"
    "dev.aerolite.Applite"
    "io.tailscale.ipn.macsys"
    "net.freemacsoft.AppCleaner"
    "theboringteam.boringnotch"
  ];

  # Read at launch by GUI apps started after the agent runs.
  updaterEnv = {
    AW_DISABLE_AUTO_UPDATE = "1"; # ActivityWatch
    BITWARDEN_NO_UPDATER = "1";
    T3CODE_DISABLE_AUTO_UPDATE = "true";
    ZED_UPDATE_EXPLANATION = "Updates are managed by Homebrew.";
  };

  heliumNoUpdate = pkgs.writeShellApplication {
    name = "helium-no-update";
    runtimeInputs = [ pkgs.jq ];
    text = builtins.readFile ./helium-no-update.sh;
  };
in
{
  targets.darwin.defaults =
    lib.genAttrs sparkleApps (_: {
      SUEnableAutomaticChecks = false;
      SUAutomaticallyUpdate = false;
    })
    // {
      # Firefox reads enterprise policies from user defaults.
      "app.zen-browser.zen" = {
        EnterprisePoliciesEnabled = true;
        DisableAppUpdate = true;
      };
      "eu.exelban.Stats"."update-interval" = "Never";
    };

  launchd.agents.no-self-update-env = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        (lib.concatStringsSep "\n" (
          lib.mapAttrsToList (k: v: "/bin/launchctl setenv ${k} ${lib.escapeShellArg v}") updaterEnv
        ))
      ];
      RunAtLoad = true;
    };
  };

  home.activation.heliumNoUpdate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe heliumNoUpdate}
  '';
}
