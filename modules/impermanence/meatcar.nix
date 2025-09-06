_: {
  environment.persistence."/persist".users.meatcar = {
    files = [ ];
    directories = [
      "Downloads"
      "Pictures"
      "Documents"
      "Sync"
      "AppImages"
      ".ssh"
      ".local/share/applications"
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
      ".config/waypaper"
      ".config/htop"
      ".cache/fuzzel"
      ".qt_material"
      ".config/pavucontrol.ini"
      {
        directory = ".local/share/flatpak";
        mode = "0755";
      }
      ".cache/flatpak"
      {
        directory = ".var";
        mode = "0755";
      }
      ".config/kdeconnect"
      ".config/clipse"
      ".local/share/khal"
      ".config/television"
      ".local/share/television"
      ".cache/nix-search-tv"
      ".config/ringboard"

      # dms
      ".config/DankMaterialShell"
      ".local/state/DankMaterialShell"
      ".cache/DankMaterialShell"
      ".config/dgop"
      ".local/share/color-schemes"
      ".cache/quickshell"
      ".config/cava"

      # wallpapers
      ".cache/swww"
      ".cache/waypaper"

      # dev
      ".config/github-copilot"
      ".npm"
      ".cache/npm"
      ".cache/pnpm"
      ".cache/.bun"
      ".cache/bun"
      ".cache/nixpkgs-review"
      ".local/share/zed"
      ".config/zed"
      ".aider"
      ".local/share/aider"
      ".aws"
      ".mcp-auth"
      ".local/share/opencode"
      {
        directory = ".cache/opencode";
        mode = "0755";
      }
      {
        directory = ".cache/uv";
        mode = "0755";
      }
      ".amp"
      ".config/amp"
      ".local/share/amp"
      ".cache/amp"
      ".infisical"

      # graphics
      ".cache/mesa_shader_cache_db"
      ".cache/radv_builtin_shaders"
      ".cache/mesa_shader_cache"

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

      # appimage
      ".cache/appimage-run"

      # helium
      ".config/net.imput.helium"

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
      {
        directory = ".local/share/Paradox Interactive";
        mode = "0755";
      }
    ];
  };
}
