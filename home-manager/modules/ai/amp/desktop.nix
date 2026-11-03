# TODO: remove this module once amp-desktop supports more than one account or window in one app.
# see https://ampcode.com/docs/apps/linux#known-limitations
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.me.amp.desktop;
  profiles = config.me.amp.profiles;
  package = pkgs.amp-desktop;
  app = "${package}/share/amp-desktop";
  schemes = [
    "x-scheme-handler/com.ampcode.amp.linux.auth"
    "x-scheme-handler/amp"
  ];
  id = name: "amp-desktop-${name}";

  # NOTE: desktopName sets the Wayland app-id; --class and CHROME_DESKTOP do not.
  asars = lib.mapAttrs (
    name: _:
    pkgs.runCommand "${id name}.asar"
      {
        nativeBuildInputs = [
          pkgs.asar
          pkgs.jq
        ];
      }
      ''
        asar extract ${app}/resources/app.asar app
        jq --arg name ${id name}.desktop '.desktopName = $name' app/package.json > package.json
        mv package.json app/package.json
        asar pack app "$out"
      ''
  ) profiles;

  launchers = lib.mapAttrs (
    name: profile:
    pkgs.writeShellApplication {
      name = "amp-desktop-${profile.alias}";
      runtimeInputs = [
        pkgs.bubblewrap
        pkgs.coreutils
      ];
      text =
        builtins.replaceStrings
          [ "@account@" "@asar@" "@app@" "@amp-desktop@" ]
          [
            (lib.escapeShellArg name)
            "${asars.${name}}"
            app
            (lib.getExe package)
          ]
          (builtins.readFile ./amp-desktop.sh);
    }
  ) profiles;
in
{
  options.me.amp = {
    desktop.enable = lib.mkEnableOption "the Amp desktop app, one instance per Amp profile";
    profiles = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options.desktop.tint = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "ImageMagick arguments that tint the profile's app icon.";
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = builtins.attrValues launchers;

    xdg.dataFile =
      lib.mapAttrs' (
        name: _:
        lib.nameValuePair "applications/${id name}.desktop" {
          source =
            pkgs.runCommand "${id name}.desktop" { nativeBuildInputs = [ pkgs.desktop-file-utils ]; }
              ''
                substitute ${package}/share/applications/amp-desktop.desktop "$out" \
                  --replace-fail 'Name=Amp' ${lib.escapeShellArg "Name=Amp (${lib.toSentenceCase name})"} \
                  --replace-fail 'Exec=amp-desktop' 'Exec=${lib.getExe launchers.${name}}' \
                  --replace-fail 'Icon=amp-desktop' 'Icon=${id name}' \
                  --replace-fail 'StartupWMClass=amp-desktop' 'StartupWMClass=${id name}'
                desktop-file-validate "$out"
              '';
        }
      ) profiles
      // lib.mapAttrs' (
        name: profile:
        lib.nameValuePair "icons/hicolor/512x512/apps/${id name}.png" {
          source = pkgs.runCommand "${id name}.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
            magick ${package}/share/icons/hicolor/512x512/apps/amp-desktop.png \
              ${lib.escapeShellArgs profile.desktop.tint} "png:$out"
          '';
        }
      ) profiles;

    # NOTE: app links do not name a profile; Junction picks one.
    xdg.mimeApps.defaultApplications = lib.genAttrs schemes (_: "re.sonny.Junction.desktop");
    xdg.mimeApps.associations.added = lib.genAttrs schemes (
      _: map (name: "${id name}.desktop") (builtins.attrNames profiles)
    );
  };
}
