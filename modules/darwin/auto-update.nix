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

  # OS → brew → darwin, in order. Runs at every boot and Sunday 4am, but
  # skips if it succeeded within the last 3 days. Brew is upgraded by the
  # homebrew module during `darwin-rebuild switch` activation.
  launchd.daemons.auto-update = {
    script = ''
      set -u
      export PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/sbin:/usr/bin:/bin
      export HOME=/var/root

      stamp=/var/db/auto-update.stamp
      if [ -f "$stamp" ] && [ "$(( $(date +%s) - $(stat -f %m "$stamp") ))" -lt 259200 ]; then
        exit 0
      fi

      # wait up to 5 minutes for a default route, then bail quietly
      for _ in $(seq 30); do
        route -n get default >/dev/null 2>&1 && break
        sleep 10
      done
      route -n get default >/dev/null 2>&1 || exit 0

      echo "=== auto-update: $(date) ==="

      # 1. macOS. Restart-required updates can't be installed unattended on
      # Apple Silicon (needs a volume owner); this stages them so the native
      # auto-installer only has the reboot left to do.
      softwareupdate --install --all || true

      # 2 + 3. flake inputs, then switch (upgrades brew during activation).
      sudo -u denys -H nix flake update --flake "${flakeDir}" || true
      export HOMEBREW_UPGRADE_GREEDY=1
      if darwin-rebuild switch --flake "${flakeDir}"; then
        touch "$stamp"
        # commit the lock bump only once it has switched successfully
        git() { sudo -u denys -H /etc/profiles/per-user/denys/bin/git -C "${flakeDir}" "$@"; }
        if ! git diff --quiet -- flake.lock; then
          git commit -m "chore(deps): nix flake update (auto)" -- flake.lock
        fi
      fi
    '';
    serviceConfig = {
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
