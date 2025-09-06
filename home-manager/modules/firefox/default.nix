{ inputs, ... }:
{
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
    source = inputs.firefox-arcwtf;
    recursive = true;
  };

}
