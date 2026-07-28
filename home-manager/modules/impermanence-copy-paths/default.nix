{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.me.impermanence.copyPaths;

  persistRoot = "${cfg.persistRoot}${config.home.homeDirectory}";

  # systemd unit names can't contain "/", and a literal "@" would make the
  # name look like a template instance. Use a plain slug.
  slug = path: lib.replaceStrings [ "/" "." ] [ "-" "-" ] path;
  unitName = path: "impermanence-copy-${slug path}";

  # Copy state between $HOME (tmpfs, wiped on boot) and the persist root.
  # Both directions no-op on a missing source: on a fresh machine there is
  # nothing saved yet, and an app that has never run leaves nothing live.
  #
  # Saves write to a temp path and mv it into place, so a crash mid-copy can't
  # leave a truncated file behind. Restores COPY rather than link, because the
  # entire point is that the live path must be a real file/dir -- see the
  # option description for why symlinks and single-file bind mounts don't work.
  syncScript = pkgs.writeShellApplication {
    name = "impermanence-copy";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      action="$1"
      rel="$2"
      live="$HOME/$rel"
      saved="${persistRoot}/$rel"

      case "$action" in
        restore)
          [ -e "$saved" ] || exit 0
          mkdir -p "$(dirname "$live")"
          # Never clobber live state that is newer than the saved copy. That
          # happens when a save was missed (e.g. hard poweroff before the
          # handler ran) and the tmpfs copy is the better one.
          if [ -e "$live" ] && [ ! "$saved" -nt "$live" ]; then
            exit 0
          fi
          tmp="$live.impermanence-tmp.$$"
          rm -rf "$tmp"
          cp -a "$saved" "$tmp"
          rm -rf "$live"
          mv -T "$tmp" "$live"
          ;;
        save)
          [ -e "$live" ] || exit 0
          mkdir -p "$(dirname "$saved")"
          tmp="$saved.impermanence-tmp.$$"
          rm -rf "$tmp"
          cp -a "$live" "$tmp"
          rm -rf "$saved"
          mv -T "$tmp" "$saved"
          ;;
      esac
    '';
  };

  mkService =
    path:
    lib.nameValuePair (unitName path) {
      Unit = {
        Description = "Copy ${path} to/from ${cfg.persistRoot}";
        PartOf = [ "graphical-session.target" ];
        # The path unit retriggers this on every change. A oneshot that is
        # started faster than the default 5-starts-per-10s limit gets marked
        # failed permanently, which silently disables persistence AND puts the
        # watching .path unit into a failed state. Opt out of rate limiting
        # entirely; the handler is a cheap copy.
        StartLimitIntervalSec = 0;
      };
      Service = {
        Type = "oneshot";
        # Keep the unit active after the restore so that stopping it at logout
        # runs ExecStop. Without this a oneshot goes inactive immediately and
        # the final save never fires.
        RemainAfterExit = true;
        ExecStart = "${lib.getExe syncScript} restore ${lib.escapeShellArg path}";
        ExecStop = "${lib.getExe syncScript} save ${lib.escapeShellArg path}";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

  # Save-on-change handler driven by the .path unit below. Separate from the
  # restore/save unit because that one is RemainAfterExit and so can't be
  # retriggered while active.
  mkSaveService =
    path:
    lib.nameValuePair "${unitName path}-save" {
      Unit = {
        Description = "Save ${path} to ${cfg.persistRoot}";
        StartLimitIntervalSec = 0;
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe syncScript} save ${lib.escapeShellArg path}";
      };
    };

  # PathChanged watches the containing directory, so it keeps working when a
  # writer replaces the file by rename() instead of modifying it in place --
  # which is exactly what the apps needing this module do.
  mkPath =
    path:
    lib.nameValuePair "${unitName path}-save" {
      Unit = {
        Description = "Watch ${path} for changes";
        PartOf = [ "graphical-session.target" ];
      };
      Path = {
        PathChanged = "${config.home.homeDirectory}/${path}";
        Unit = "${unitName path}-save.service";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
in
{
  options.me.impermanence.copyPaths = {
    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ ".local/share/recently-used.xbel" ];
      description = ''
        Home-relative files/directories copied in on login and back out on
        every change. An escape hatch of last resort -- prefer
        `home.persistence` whenever it works.

        Reach for this only when the live path must be a real file and the
        writer replaces it via rename():

          - A symlink into the persist root gets destroyed once the temp
            file is renamed over the *link* path rather than the target --
            GLib's `g_file_set_contents` does this, and bind-mounting the
            target doesn't help since the rename still lands on the tmpfs
            side.
          - A single-file bind mount can't be renamed over at all: rename()
            returns EBUSY (nix-community/impermanence#107).
          - Redirecting the app is often impossible: GTK hardcodes
            "recently-used.xbel" under XDG_DATA_HOME, too broad to repoint.

        This is a copy, not a mount: eventually consistent, and a hard
        poweroff mid-write can lose the last change.
      '';
    };

    persistRoot = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
      description = "Filesystem root that survives reboots.";
    };
  };

  config = lib.mkIf (cfg.paths != [ ]) {
    systemd.user.services = lib.listToAttrs (map mkService cfg.paths ++ map mkSaveService cfg.paths);
    systemd.user.paths = lib.listToAttrs (map mkPath cfg.paths);
  };
}
