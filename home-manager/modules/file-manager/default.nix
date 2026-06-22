{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.me.fileManager;
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
        kdePackages.kservice # kbuildsycoca6, to (re)build the "Open With" app catalog
        kdePackages.baloo # timeline:/ KIO worker + baloo_file indexer (Places "Modified Today/…")
        # Qt platform theme: qgnomeplatform reads the org.freedesktop.appearance
        # color-scheme from the (gnome) Settings portal and swaps the adwaita /
        # adwaita-dark style live, so Dolphin follows darkman. adwaita-qt6
        # provides those styles; qadwaitadecorations gives Adwaita CSD.
        qgnomeplatform-qt6
        adwaita-qt6
        qadwaitadecorations-qt6
      ];
      dbus.packages = [ pkgs.kdePackages.dolphin ];

      # qt.enable only wires QT_PLUGIN_PATH/QML2_IMPORT_PATH so the plugins above
      # resolve. We deliberately do NOT set qt.platformTheme/style: the HM module
      # would export QT_STYLE_OVERRIDE, which pins a static light style and stops
      # qgnomeplatform from swapping light/dark on color-scheme changes
      # (FedoraQt/qgnomeplatform#80). Selecting "gnome" by env instead.
      qt.enable = true;
      home.sessionVariables.QT_QPA_PLATFORMTHEME = "gnome";
      systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME = "gnome";

      # Force GTK apps to use the (KDE) file-chooser portal instead of their
      # built-in dialog. Mirror modules/wayland's dual-set pattern so the var
      # reaches both session children and user services / D-Bus activation.
      home.sessionVariables.GTK_USE_PORTAL = "1";
      systemd.user.sessionVariables.GTK_USE_PORTAL = "1";

      # Open folders (inode/directory) and FileManager1 "show in folder" in Dolphin.
      xdg.mimeApps.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";

      # Dolphin's "Open With" application list is built by KSycoca from an XDG
      # application menu. Without Plasma there is no applications.menu, so the
      # list is empty. Provide a minimal one (all apps, plus any system menu
      # fragments via DefaultMergeDirs). KSycoca finds $XDG_CONFIG_HOME/menus/
      # and rebuilds on next KDE app launch.
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

      # Point Dolphin's "Open Terminal" action at ghostty. Written via
      # kwriteconfig6 (touches only this key) so dolphinrc/kdeglobals stay
      # mutable for Dolphin's own view/window state. Best-effort: the key is
      # read by KDE's default-terminal lookup.
      # Runs after linkGeneration so ~/.config/kdeglobals (a symlink to /persist)
      # exists, and ensures its target exists first — KConfig silently drops
      # writes through a dangling symlink (see impermanence.nix).
      home.activation.dolphinTerminal = lib.mkIf config.programs.ghostty.enable (
        lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          cfg="$HOME/.config/kdeglobals"
          target="$(readlink -f "$cfg")"
          if [ -n "$target" ] && [ ! -e "$target" ]; then
            run mkdir -p "$(dirname "$target")"
            run touch "$target"
          fi
          run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
            --file "$cfg" --group General --key TerminalApplication ghostty
        ''
      );

      # Baloo backs Dolphin's timeline:/ Places ("Modified Today/…") and search.
      # Index ONLY the non-dotfile folders directly under $HOME: the "$HOME"/*/
      # glob skips .* dirs, so HM's ~/.config and the many store symlinks are
      # never crawled. Using an include list (not excludes) means future
      # dotfolders are ignored too. "only basic indexing" covers mtime/metadata
      # (enough for the timeline) without the heavy content extractor.
      # baloofilerc is on tmpfs (not persisted), so it's rebuilt each activation.
      home.activation.balooFolders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # Drop a stale store symlink from a prior generation so we can write it.
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

      # baloo_file's XDG autostart is OnlyShowIn=KDE;GNOME and its packaged
      # systemd unit has an ExecCondition pointing at plasma-workspace (not
      # installed), so start it ourselves. baloo is independent of kded6 and
      # only owns org.kde.baloo (no StatusNotifierWatcher), so it won't fight
      # the DMS tray.
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
