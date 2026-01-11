{ pkgs, ... }:
{

  home.sessionVariables = {
    BROWSER = "dms open";
  };
  xdg.mimeApps.defaultApplications =
    let
      dms = "dms-open.desktop";
      papers = "org.gnome.Papers.desktop";
    in
    {
      "application/x-extension-shtml" = dms;
      "application/x-extension-xhtml" = dms;
      "application/x-extension-html" = dms;
      "application/x-extension-xht" = dms;
      "application/x-extension-htm" = dms;
      "x-scheme-handler/unknown" = dms;
      "x-scheme-handler/mailto" = dms;
      "x-scheme-handler/chrome" = dms;
      "x-scheme-handler/about" = dms;
      "x-scheme-handler/https" = dms;
      "x-scheme-handler/http" = dms;
      "application/xhtml+xml" = dms;
      "application/json" = dms;
      "text/html" = dms;
      "application/pdf" = papers;
    };
  home.packages = [
    (pkgs.writeShellScriptBin "mime-apps-list" ''
      ls /run/current-system/sw/share/applications # for global packages
      ls /etc/profiles/per-user/$(id -n -u)/share/applications # for user packages
      ls ~/.nix-profile/share/applications # for home-manager packages
    '')
    pkgs.shared-mime-info
  ];
}
