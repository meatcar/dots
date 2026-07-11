# Unattended updates for a rarely-used machine: macOS settings are declared
# below, and a launchd daemon runs on boot (throttled) since the usual
# overnight windows never happen when the laptop is asleep or off.
{ config, ... }:
let
  flakeDir = config.environment.variables.NH_FLAKE;
in
{
  # macOS + App Store: check, download, and install automatically.
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  system.defaults.CustomSystemPreferences = {
    "/Library/Preferences/com.apple.SoftwareUpdate" = {
      AutomaticCheckEnabled = true;
      AutomaticDownload = true;
      ConfigDataInstall = true; # XProtect etc.
      CriticalUpdateInstall = true;
    };
    "/Library/Preferences/com.apple.commerce".AutoUpdate = true;
  };

  # OS → brew → darwin, in order (see auto-update.sh). Runs at every boot
  # and Sunday 4am, but skips if it succeeded within the last 3 days. Brew
  # is upgraded by the homebrew module during `darwin-rebuild switch`
  # activation.
  launchd.daemons.auto-update = {
    script = builtins.readFile ./auto-update.sh;
    serviceConfig = {
      EnvironmentVariables.FLAKE_DIR = flakeDir;
      RunAtLoad = true;
      StartCalendarInterval = [
        {
          Weekday = 0;
          Hour = 4;
          Minute = 0;
        }
      ];
      StandardOutPath = "/var/log/auto-update.log";
      StandardErrorPath = "/var/log/auto-update.log";
    };
  };
}
