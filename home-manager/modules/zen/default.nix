{ pkgs, ... }:
{
  programs.zen-browser.nativeMessagingHosts = [ pkgs.firefoxpwa ];
  programs.zen-browser = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableAppUpdate = false;
      ExtensionSettings."{f0bda7ce-0cda-42dc-9ea8-126b20fed280}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/hister/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };

}
