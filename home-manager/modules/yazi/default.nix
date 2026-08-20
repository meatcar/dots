{ config, pkgs, ... }:
let
  osc7 = pkgs.yaziPlugins.mkYaziPlugin {
    pname = "osc7.yazi";
    version = "0-unstable-2026-01-24";

    src = pkgs.fetchFromGitHub {
      owner = "coder0x6675";
      repo = "osc7.yazi";
      rev = "ae73046482b82dd71fc07eb300fe54720e95dc9f";
      hash = "sha256-+uX/e8pnfiv82kUdLBif8yTd5vKhdG85E2ct/t/tBzk=";
    };

    meta = {
      description = "Sync the terminal's working directory with yazi's via OSC 7";
      homepage = "https://github.com/coder0x6675/osc7.yazi";
      license = pkgs.lib.licenses.mit;
    };
  };

  removableMounts = "/run/media/${config.home.username}/**/*";
  # $XDG_RUNTIME_DIR/gvfs; the uid is not known at eval time.
  gvfsMounts = "/run/user/*/gvfs/**/*";
in
{
  # Preview deps HM's yazi module does not pull in: PDF (poppler), SVG/large
  # images (resvg, imagemagick). Archive (7z) and video thumbs come from
  # p7zip-rar and ffmpegthumbnailer in common.nix.
  home.packages = with pkgs; [
    poppler-utils
    resvg
    imagemagick

    trash-cli # recycle-bin.yazi shells out to trash-list/-restore/-rm/-empty
    ouch # ouch.yazi
  ];

  programs.yazi = {
    enable = true;

    plugins = {
      inherit (pkgs.yaziPlugins)
        chmod
        diff
        jjui
        ouch
        toggle-pane
        ;

      gvfs = {
        package = pkgs.yaziPlugins.gvfs;
        setup = true;
        settings = {
          # Default is ~/.config/yazi/, which Home Manager owns; these files are
          # written at runtime, so they need a writable and persisted home.
          save_path = "${config.home.homeDirectory}/.local/state/yazi/gvfs.private";
          save_path_automounts = "${config.home.homeDirectory}/.local/state/yazi/gvfs_automounts.private";
          password_vault = "keyring";
        };
      };

      recycle-bin = {
        package = pkgs.yaziPlugins.recycle-bin;
        setup = true;
      };

      starship = {
        package = pkgs.yaziPlugins.starship;
        setup = true;
      };

      osc7 = {
        package = osc7;
        setup = true;
      };
    };

    settings.plugin = {
      prepend_preloaders = [
        {
          url = removableMounts;
          run = "noop";
        }
        {
          url = gvfsMounts;
          run = "noop";
        }
      ];
      prepend_previewers = [
        # Keep directory previews; the noop rules below only silence files.
        {
          url = "*/";
          run = "folder";
        }
        {
          url = removableMounts;
          run = "noop";
        }
        {
          url = gvfsMounts;
          run = "noop";
        }
      ];
    };

    keymap = {
      # mgr = file-browser layer. The old `input` layer only fires inside text
      # prompts, where `shell` is not a valid command, so `!` did nothing there.
      mgr.prepend_keymap = [
        {
          run = "help";
          on = [ "<A-?>" ];
          desc = "Open help";
        }
        {
          run = "shell \"$SHELL\" --block";
          on = [ "!" ];
          desc = "Open shell here";
        }

        {
          run = "plugin jjui";
          on = [
            "g"
            "j"
          ];
          desc = "Open jjui";
        }

        {
          run = "plugin toggle-pane min-preview";
          on = [ "T" ];
          desc = "Show or hide the preview pane";
        }
        {
          run = "plugin toggle-pane max-preview";
          on = [ "<A-t>" ];
          desc = "Maximize or restore the preview pane";
        }

        {
          run = "plugin chmod";
          on = [
            "c"
            "m"
          ];
          desc = "Chmod selected files";
        }
        # NOTE: upstream suggests <C-d>, which is yazi's half-page-down.
        {
          run = "plugin diff";
          on = [ "<A-d>" ];
          desc = "Diff the selected with the hovered file";
        }
        {
          run = "plugin ouch";
          on = [ "C" ];
          desc = "Compress with ouch";
        }

        {
          run = "plugin recycle-bin";
          on = [
            "R"
            "b"
          ];
          desc = "Open recycle bin menu";
        }

        {
          run = "plugin gvfs -- select-then-mount --jump";
          on = [
            "M"
            "m"
          ];
          desc = "Select a device to mount, then jump to it";
        }
        {
          run = "plugin gvfs -- select-then-unmount --eject";
          on = [
            "M"
            "u"
          ];
          desc = "Select a device to unmount and eject";
        }
        {
          run = "plugin gvfs -- select-then-unmount --eject --force";
          on = [
            "M"
            "U"
          ];
          desc = "Select a device to force unmount and eject";
        }
        {
          run = "plugin gvfs -- remount-current-cwd-device";
          on = [
            "M"
            "R"
          ];
          desc = "Remount the device under the cwd";
        }
        {
          run = "plugin gvfs -- add-mount";
          on = [
            "M"
            "a"
          ];
          desc = "Add a GVFS mount URI";
        }
        {
          run = "plugin gvfs -- edit-mount";
          on = [
            "M"
            "e"
          ];
          desc = "Edit a GVFS mount URI";
        }
        {
          run = "plugin gvfs -- remove-mount";
          on = [
            "M"
            "r"
          ];
          desc = "Remove a GVFS mount URI";
        }
        {
          run = "plugin gvfs -- jump-to-device --automount";
          on = [
            "g"
            "m"
          ];
          desc = "Automount, then jump to a device";
        }
        {
          run = "plugin gvfs -- jump-back-prev-cwd";
          on = [
            "`"
            "`"
          ];
          desc = "Jump back to the pre-device cwd";
        }
      ];
    };
  };
}
