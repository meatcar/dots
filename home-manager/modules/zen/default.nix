{ pkgs, ... }:
{
  programs.zen-browser.nativeMessagingHosts = [
    # nixpkgs 26.05: firefoxpwa 2.18.2 no longer ships lib/firefoxpwa/ in its
    # output, so the wrapper buildCommand fails touching is-packaged-app.
    (pkgs.firefoxpwa.overrideAttrs (old: {
      buildCommand =
        builtins.replaceStrings
          [ ''touch "$out/lib/firefoxpwa/is-packaged-app"'' ]
          [ ''mkdir -p "$out/lib/firefoxpwa"; touch "$out/lib/firefoxpwa/is-packaged-app"'' ]
          old.buildCommand;
    }))
  ];
  programs.zen-browser = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableAppUpdate = false;
    };
  };

  # Force XWayland to work around a Wayland repaint freeze loop.
  # https://bugzilla.mozilla.org/show_bug.cgi?id=1515448
  xdg.desktopEntries.zen-beta = {
    name = "Zen Browser (Beta)";
    genericName = "Web Browser";
    exec = "env MOZ_ENABLE_WAYLAND=0 zen-beta --name zen-beta %U";
    icon = "zen-browser";
    terminal = false;
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    startupNotify = true;
    settings.StartupWMClass = "zen-beta";
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    actions = {
      new-window = {
        name = "New Window";
        exec = "env MOZ_ENABLE_WAYLAND=0 zen-beta --new-window %U";
      };
      new-private-window = {
        name = "New Private Window";
        exec = "env MOZ_ENABLE_WAYLAND=0 zen-beta --private-window %U";
      };
      profile-manager-window = {
        name = "Profile Manager";
        exec = "env MOZ_ENABLE_WAYLAND=0 zen-beta --ProfileManager";
      };
    };
  };
}
