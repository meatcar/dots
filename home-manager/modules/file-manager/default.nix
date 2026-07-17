{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.me.fileManager;

  # import a DMS .colors scheme into kdeglobals (where KDE reads its colors)
  applyKdeColors = pkgs.writeShellApplication {
    name = "apply-kde-colors";
    runtimeInputs = [ pkgs.kdePackages.kconfig ]; # kwriteconfig6
    text = builtins.readFile ./apply-kde-colors.sh;
  };
in
{
  options.me.fileManager = lib.mkOption {
    type = lib.types.enum [
      "nautilus"
      "dolphin"
    ];
    default = "nautilus";
    description = ''
      Graphical file manager to use. Drives the installed packages, the niri
      `Mod+E` keybind, the `niri-portals.conf` FileChooser routing, D-Bus
      service registration, and impermanence persistence. Switch by changing
      this single value (see also the NixOS-side `xdg.portal.extraPortals` in
      systems/watson, which is gated on this option).
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg == "nautilus") {
      home.packages = [
        pkgs.nautilus
        pkgs.nautilus-python
        pkgs.nautilus-open-any-terminal
        pkgs.file-roller
      ];
      home.sessionVariables = {
        NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
      };
      dconf.settings."org.gnome.desktop.privacy" = {
        remember-recent-files = true;
      };
      dconf.settings."org.gnome.nautilus.preferences" = {
        show-recent-files = "always";
      };
      dconf.settings."com.github.stunkymonkey.nautilus-open-any-terminal" = {
        terminal = lib.mkIf config.programs.ghostty.enable "ghostty";
      };
      dbus.packages = [ pkgs.nautilus ];
    })

    (lib.mkIf (cfg == "dolphin") {
      home.packages = with pkgs; [
        kdePackages.dolphin
        kdePackages.ark
        kdePackages.ffmpegthumbs
        kdePackages.kdegraphics-thumbnailers
        ffmpegthumbnailer
        kdePackages.kservice # kbuildsycoca6, rebuilds the "Open With" catalog
        kdePackages.kio # KIO workers (file://) for non-Dolphin Qt apps
        kdePackages.baloo # timeline:/ worker + file indexer
        # KDE platform theme: palette from kdeglobals, widget style from breeze
        kdePackages.plasma-integration
        kdePackages.breeze
      ];
      dbus.packages = [ pkgs.kdePackages.dolphin ];

      # qt.enable wires QT_PLUGIN_PATH. theme via env, not qt.platformTheme, to
      # avoid QT_STYLE_OVERRIDE: style stays breeze, only colors swap on recolor.
      qt.enable = true;
      home.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";
      systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";

      # DMS writes a KDE .colors on every recolor; import its [Colors:*] into
      # kdeglobals (--notify => live re-read) so Dolphin tracks Material You.
      # no After=dms: WantedBy=graphical-session already orders us before the
      # target, and dms is after it, so After=dms would form an ordering cycle.
      systemd.user.services.dolphin-colors = {
        Unit.Description = "Import DMS matugen color scheme into kdeglobals";
        Service = {
          Type = "oneshot";
          ExecStart = "${lib.getExe applyKdeColors} %h/.local/share/color-schemes/DankMatugen.colors DankMatugen";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      systemd.user.paths.dolphin-colors = {
        Unit = {
          Description = "Watch DMS matugen color scheme for changes";
          # watch before dms: PathChanged ignores writes that land before it's
          # active, so we'd miss DMS's first recolor otherwise.
          Before = [ "dms.service" ];
        };
        Path = {
          PathChanged = "%h/.local/share/color-schemes/DankMatugen.colors";
          Unit = "dolphin-colors.service";
        };
        Install.WantedBy = [
          "dms.service"
          "graphical-session.target"
        ];
      };

      # route GTK dialogs through the KDE portal; dual-set for services/dbus too
      home.sessionVariables.GTK_USE_PORTAL = "1";
      systemd.user.sessionVariables.GTK_USE_PORTAL = "1";

      # open folders + "show in folder" in Dolphin
      xdg.mimeApps.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";

      # no Plasma => no applications.menu, so "Open With" is empty. seed a
      # minimal one for KSycoca to rebuild from.
      xdg.configFile."menus/applications.menu".text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN" "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
        <Menu>
          <Name>Applications</Name>
          <DefaultAppDirs/>
          <DefaultDirectoryDirs/>
          <DefaultMergeDirs/>
          <Include><All/></Include>
        </Menu>
      '';

      # seed kdeglobals key-by-key (stays mutable for Dolphin state + colors).
      # Icons.Theme mirrors gtk.iconTheme; KDE ignores the gsettings icon theme.
      # KConfig silently drops writes through a dangling symlink;
      # ensureDolphinPersistTargets (impermanence.nix) pre-creates the /persist
      # targets first.
      qt.kde.settings.kdeglobals =
        lib.optionalAttrs (config.gtk.iconTheme != null) {
          Icons.Theme = config.gtk.iconTheme.name;
        }
        // lib.optionalAttrs config.programs.ghostty.enable {
          General.TerminalApplication = "ghostty";
        };

      # index only non-dotfile top-level dirs ($HOME/*/ skips .*); basic indexing
      # = mtime/metadata, no content extractor. baloofilerc is on tmpfs, rebuilt
      # each activation.
      home.activation.balooFolders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # drop a stale store symlink so we can write baloofilerc
        if [ -L "$HOME/.config/baloofilerc" ]; then
          run rm -f "$HOME/.config/baloofilerc"
        fi
        baloofolders=""
        for d in "$HOME"/*/; do
          [ -d "$d" ] || continue
          baloofolders="$baloofolders''${baloofolders:+,}$d"
        done
        kwc=${pkgs.kdePackages.kconfig}/bin/kwriteconfig6
        run "$kwc" --file "$HOME/.config/baloofilerc" \
          --group "Basic Settings" --key Indexing-Enabled true
        run "$kwc" --file "$HOME/.config/baloofilerc" \
          --group General --key "only basic indexing" true
        run "$kwc" --file "$HOME/.config/baloofilerc" \
          --group General --key folders "$baloofolders"
      '';

      # baloo's autostart/unit expect Plasma, so start it ourselves. owns only
      # org.kde.baloo, no StatusNotifierWatcher, so no conflict with the DMS tray.
      systemd.user.services.kde-baloo = {
        Unit = {
          Description = "Baloo File Indexer Daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = "${pkgs.kdePackages.baloo}/libexec/kf6/baloo_file";
          BusName = "org.kde.baloo";
          Slice = "background.slice";
          Restart = "on-failure";
          RestartSec = 5;
          MemoryHigh = "25%";
        };
      };
    })
  ];
}
