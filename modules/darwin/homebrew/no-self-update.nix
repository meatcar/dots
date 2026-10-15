# Brew upgrades the casks, so turn off app self-updaters that only obey
# machine-wide policy. Per-user switches live in
# home-manager/modules/brew/no-self-update.nix.
{ lib, pkgs, ... }:
let
  # see https://learn.microsoft.com/en-us/deployedge/edge-learnmore-edgeupdater-for-macos
  edgeUpdater = pkgs.writeText "com.microsoft.EdgeUpdater.plist" (
    lib.generators.toPlist { escape = true; } {
      updatePolicies.global.UpdateDefault = 3; # updates disabled
    }
  );
in
{
  system.activationScripts.postActivation.text = ''
    mkdir -p "/Library/Managed Preferences"
    install -m 644 -o root -g wheel ${edgeUpdater} "/Library/Managed Preferences/com.microsoft.EdgeUpdater.plist"
  '';
}
