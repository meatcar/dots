{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  browsers = {
    "chromium-browser.desktop" = "--incognito";
    "helium.desktop" = "--incognito";
    "microsoft-edge.desktop" = "--inprivate";
    "com.microsoft.Edge.desktop" = "--inprivate";
    "vivaldi-stable.desktop" = "--incognito";
  };
in
{
  xdg.dataFile = lib.mapAttrs' (
    desktopFile: privateFlag:
    lib.nameValuePair "applications/${desktopFile}" {
      source =
        pkgs.runCommand desktopFile
          {
            nativeBuildInputs = [
              pkgs.python3
              pkgs.desktop-file-utils
            ];
            desktopSource = "${
              if desktopFile == "helium.desktop" then osConfig.system.path else config.home.path
            }/share/applications/${desktopFile}";
            inherit privateFlag;
          }
          ''
            python3 ${./browser-actions.py}
            desktop-file-validate "$out"
          '';
    }
  ) browsers;
}
