{ pkgs, ... }:
{
  programs.zen-browser.nativeMessagingHosts = [ pkgs.firefoxpwa ];
  programs.zen-browser.suppressXdgMigrationWarning = true;
  programs.zen-browser = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableAppUpdate = false;
    };
  };
}
