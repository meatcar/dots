{ pkgs, ... }:
{
  programs.zen-browser.nativeMessagingHosts = [ pkgs.firefoxpwa ];
  programs.zen-browser = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableAppUpdate = false;
    };
  };
  xdg.mimeApps.defaultApplications = builtins.listToAttrs (
    map
      (name: {
        inherit name;
        value = "zen.desktop";
      })
      [
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-html"
        "application/x-extension-xht"
        "application/x-extension-htm"
        "x-scheme-handler/unknown"
        "x-scheme-handler/mailto"
        "x-scheme-handler/chrome"
        "x-scheme-handler/about"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/xhtml+xml"
        "application/json"
        # "text/plain"
        "text/html"
      ]
  );
}
