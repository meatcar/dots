{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  # NOTE: Chromium profiles share one process and one Wayland app-id; separate
  # user data dirs + --class give each profile its own app-id for niri rules.
  heliumProfiles = {
    helium = {
      name = "Helium (Personal)";
      args = [ ];
      tint = [
        "-channel"
        "RGB"
        "-fill"
        "#985bd3"
        "-colorize"
        "28"
        "+channel"
      ];
    };
    helium-alipes = {
      name = "Helium (Alipes)";
      args = [
        "--user-data-dir=${config.xdg.configHome}/net.imput.helium-alipes"
        "--profile-directory=Profile 1"
        "--class=helium-alipes"
      ];
      tint = [
        "-modulate"
        "70,60,44"
      ];
    };
  };

  browsers =
    lib.mapAttrs
      (desktopFile: privateFlag: {
        source = "${config.home.path}/share/applications/${desktopFile}";
        inherit privateFlag;
        args = [ ];
        overrides = { };
      })
      {
        "chromium-browser.desktop" = "--incognito";
        "microsoft-edge.desktop" = "--inprivate";
        "com.microsoft.Edge.desktop" = "--inprivate";
        "vivaldi-stable.desktop" = "--incognito";
      }
    // lib.mapAttrs' (
      class: profile:
      lib.nameValuePair "${class}.desktop" {
        source = "${osConfig.system.path}/share/applications/helium.desktop";
        privateFlag = "--incognito";
        inherit (profile) args;
        overrides = {
          Name = profile.name;
          Icon = class;
          StartupWMClass = class;
        };
      }
    ) heliumProfiles;
in
{
  xdg.dataFile =
    lib.mapAttrs' (
      desktopFile: browser:
      lib.nameValuePair "applications/${desktopFile}" {
        source =
          pkgs.runCommand desktopFile
            {
              nativeBuildInputs = [
                pkgs.python3
                pkgs.desktop-file-utils
              ];
              desktopSource = browser.source;
              inherit (browser) privateFlag;
              execArgs = builtins.toJSON browser.args;
              overrides = builtins.toJSON browser.overrides;
            }
            ''
              python3 ${./browser-actions.py}
              desktop-file-validate "$out"
            '';
      }
    ) browsers
    // lib.mapAttrs' (
      class: profile:
      lib.nameValuePair "icons/hicolor/256x256/apps/${class}.png" {
        source = pkgs.runCommand "${class}.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
          magick ${osConfig.system.path}/share/icons/hicolor/256x256/apps/helium.png \
            ${lib.escapeShellArgs profile.tint} "png:$out"
        '';
      }
    ) heliumProfiles;
}
