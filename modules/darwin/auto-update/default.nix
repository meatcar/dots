# Unattended updates for a rarely-used laptop. macOS updates itself natively
# (settings below). A launchd daemon does the rest (see auto-update.sh):
#   nightly: brew update + upgrade --greedy
#   weekly:  nix flake update + darwin-rebuild switch
# It fires hourly, at boot, and at 03:00 (a scheduled wake), but each job runs
# once per period, so missed runs catch up as soon as the Mac is up.
{ config, ... }:
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

  launchd.daemons.auto-update = {
    script = builtins.readFile ./auto-update.sh;
    serviceConfig = {
      EnvironmentVariables = {
        FLAKE_DIR = config.environment.variables.NH_FLAKE;
        OWNER = config.system.primaryUser;
      };
      RunAtLoad = true;
      StartInterval = 3600;
      StartCalendarInterval = [
        {
          Hour = 3;
          Minute = 0;
        }
      ];
      StandardOutPath = "/var/log/auto-update.log";
      StandardErrorPath = "/var/log/auto-update.log";
    };
  };

  # NOTE: wake from sleep just before the 03:00 run. Replaces any other
  # `pmset repeat` schedule.
  system.activationScripts.postActivation.text = ''
    pmset repeat wakeorpoweron MTWRFSU 02:58:00
  '';
}
