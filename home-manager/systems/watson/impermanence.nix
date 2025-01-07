{
  config,
  lib,
  ...
}: {
  home.persistence."/persist/home/meatcar" = {
    allowOther = true;
    files = [
      # ".config/user-dirs.dirs"
      # ".config/user-dirs.locale"
      ".config/monitors.xml"
    ];
    directories =
      [
        "Downloads"
        "Sync"
        ".ssh"
        # ".cache/nix"
        # ".local/state/nix"
        ".local/share/nix"
        ".cache/gnome-desktop-thumbnailer"
        ".local/state/home-manager"
        ".local/share/gnome-shell"
        ".local/share/gnome-settings-daemon"
        ".local/share/nautilus"
        ".local/share/icc"
        ".cache/tracker3"
        ".cache/darkman"
        ".cache/fontconfig"
        ".config/dconf"
        ".config/gtk-3.0"
        ".config/gtk-4.0"
        ".config/keyrings"
        ".config/gvfs-metadata"
        ".config/evolution"
        ".config/autostart"
        ".local/share/zoxide"
        ".local/state/syncthing"
        ".cache/less"
        ".local/state/wireplumber"
        ".config/op"
        ".config/aws"
        ".config/1Password"
        ".cache/npm"
        ".cache/pnpm"
        ".cache/nixpkgs-review"
      ]
      ++ lib.optional config.programs.bat.enable ".cache/bat"
      ++ lib.optional config.programs.gh.enable ".config/gh"
      ++ lib.optional config.programs.ssh.enable ".cache/ssh"
      ++ lib.optional config.programs.starship.enable ".cache/starship"
      ++ lib.optional config.programs.fish.enable ".local/share/fish"
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
      ++ lib.optionals config.programs.neovim.enable [
        ".local/share/nvim"
        ".cache/nvim"
        ".local/state/nvim"
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
      ];
  };
}
