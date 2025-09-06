{ pkgs, lib, ... }:
let
  package = pkgs.junction;
in
{
  home.packages = [ package ];
  home.sessionVariables = {
    BROWSER = "${lib.getExe package}";
  };
  xdg.mimeApps.defaultApplications = builtins.listToAttrs (
    map
      (name: {
        inherit name;
        value = "re.sonny.Junction.desktop";
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
