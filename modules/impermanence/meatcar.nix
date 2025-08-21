_: {
  environment.persistence."/persist".users.meatcar = {
    files = [ ];
    directories = [
      "Downloads"
      "Pictures"
      "Documents"
      "Sync"
      ".ssh"
      ".local/share/calendars"
      ".local/share/vdirsyncer"
      ".local/share/fonts"
      ".local/share/nix"
      ".local/share/zoxide"
      ".local/state/syncthing"
      ".cache/less"
      ".local/state/wireplumber"
      ".cache/thumbnails"
      ".local/share/man"

      # wallpapers
      ".cache/swww"
      ".cache/waypaper"

      # dev
      ".config/github-copilot"
      ".npm"
      ".cache/npm"
      ".cache/pnpm"
      ".cache/nixpkgs-review"
      ".local/share/zed"
      ".config/zed"
      ".aider"
      ".aws"
      ".mcp-auth"
      ".local/share/opencode"
      {
        directory = ".cache/opencode";
        mode = "0755";
      }

      # graphics
      ".cache/mesa_shader_cache_db"
      ".cache/radv_builtin_shaders"

      # audio
      ".config/easyeffects"

      # spotify
      ".config/spotifyd"
      ".cache/spotifyd"
      ".config/spotify-player"
      ".cache/spotify-player"

      # 1password
      ".config/aws"
      ".config/1Password"
      {
        directory = ".config/op";
        mode = "0700";
      }

      # epiphany
      ".cache/epiphany"
      ".local/share/epiphany"

      # podman
      ".local/share/containers"

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

      # code
      ".cache/treefmt"
      ".cache/pre-commit"
      ".cache/nix"
      ".cursor"
      ".config/Cursor"
      ".config/configstore"
      {
        directory = ".local/share/uv";
        mode = "0755";
      }

      # steam
      {
        directory = ".local/share/Steam";
        mode = "0755";
      }
      {
        directory = ".paradoxlauncher";
        mode = "0755";
      }
    ];
  };
}
