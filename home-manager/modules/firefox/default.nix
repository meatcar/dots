{specialArgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        # for arcwtf
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "uc.tweak.popup-search" = false;
        "uc.tweak.hide-sidebar-header" = true;
        "uc.tweak.longer-sidebar" = false;

        # fix youtube stutter
        "layers.acceleration.force-enabled" = true;
      };
    };
  };

  home.file.".mozilla/firefox/default/chrome" = {
    source = specialArgs.inputs.firefox-arcwtf;
    recursive = true;
  };

  xdg.mime.enable = true;
  xdg.mimeApps.defaultApplications = let
    browser = "firefox.desktop";
  in {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
  };
}
