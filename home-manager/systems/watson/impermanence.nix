{
  config,
  lib,
  ...
}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    allowOther = true;
    files = [
      # FIXME: don't reliably work, see https://github.com/nix-community/impermanence/issues/107
      # ".config/user-dirs.dirs"
      # ".config/user-dirs.locale"
      ".config/monitors.xml"
      # ".config/mimeapps.list"
    ];
    directories =
      [
        "Downloads"
        "Pictures"
        "Documents"
        "Sync"
        ".ssh"
        ".local/share/calendars"
        ".local/share/vdirsyncer"
        ".local/share/fonts"
        # ".cache/nix"
        # ".local/state/nix"
        ".local/share/nix"
        ".local/share/zoxide"
        ".local/state/syncthing"
        ".cache/less"
        ".local/state/wireplumber"
        ".config/aws"
        ".config/1Password"
        {
          directory = ".local/share/containers"; # podman
          method = "symlink";
        }
        {
          directory = ".npm";
          method = "symlink";
        }
        {
          directory = ".cache/typescript";
          method = "symlink";
        }
        ".cache/npm"
        ".cache/pnpm"
        {
          directory = ".hex";
          method = "symlink";
        }
        {
          directory = ".mix";
          method = "symlink";
        }
        ".cache/nixpkgs-review"
        ".local/share/zed"
        ".config/zed"
        ".aider"
      ]
      ++ lib.optional config.programs.bat.enable ".cache/bat"
      ++ lib.optional config.programs.gh.enable ".config/gh"
      ++ lib.optional config.programs.ssh.enable ".cache/ssh"
      ++ lib.optional config.programs.starship.enable ".cache/starship"
      ++ lib.optionals config.programs.fish.enable [
        ".local/share/fish"
        ".cache/fish"
      ]
      ++ lib.optionals config.programs.vscode.enable [
        ".vscode"
        ".config/Code"
      ]
      ++ lib.optionals config.programs.direnv.enable [
        ".cache/direnv"
        ".local/share/direnv"
      ]
      ++ lib.optionals config.programs.firefox.enable [
        ".cache/mozilla"
        ".mozilla/firefox"
      ]
      ++ lib.optionals config.programs.chromium.enable [
        ".cache/chromium"
        ".config/chromium"
      ]
      ++ lib.optionals config.programs.neovim.enable [
        ".local/share/nvim"
        ".cache/nvim"
        ".local/state/nvim"
      ]
      ++ lib.optionals config.services.copyq.enable [
        ".config/copyq"
        ".qt_material"
        ".local/share/copyq"
      ]
      ++ [
        # gnome-shell
        ".cache/gnome-desktop-thumbnailer"
        ".local/state/home-manager"
        ".local/share/gnome-shell"
        ".local/share/gnome-settings-daemon"
        ".local/share/nautilus"
        ".local/share/icc"
        ".cache/tracker3"
        ".cache/darkman"
        ".cache/fontconfig"
        ".cache/dconf"
        ".config/dconf"
        ".config/gtk-3.0"
        ".config/gtk-4.0"
        ".local/share/keyrings"
        ".local/share/gvfs-metadata"
        ".local/share/evolution"
        ".config/autostart"
        ".cache/libgweather"
        ".cache/geocode-glib"
        ".cache/clipboard-indicator@tudmotu.com"
      ]
      ++ [
        ".config/vivaldi"
        ".cache/vivaldi"
        ".local/lib/vivaldi"
      ]
      ++ [
        ".config/activitywatch"
        ".cache/activitywatch"
        ".local/share/activitywatch"
        ".config/awatcher"
      ]
      ++ [".config/opensnitch"]
      ++ [".config/obsidian"]
      ++ [
        {
          # seems to consume a lot of CPU as a non-symlink
          directory = ".continue";
          method = "symlink";
        }
        ".cache/treefmt"
        ".cache/pre-commit"
        ".cache/nix"
        ".cursor"
        ".config/Cursor"
      ];
  };
}
