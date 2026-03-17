{
  config,
  lib,
  ...
}:
{
  home.persistence."/persist" = {
    files = [
      # FIXME: don't reliably work, see https://github.com/nix-community/impermanence/issues/107
      # ".config/user-dirs.dirs"
      # ".config/user-dirs.locale"
      # ".config/monitors.xml"
      # ".config/mimeapps.list"
      ".clasprc.json" # for clasp gscript upload tool
      ".config/apps.json" # for gearlever. Doesn't make a subdir.
      ".claude.json"
    ];
    directories = [
      # user dirs
      "Downloads"
      "Pictures"
      "Documents"
      "Sync"
      "AppImages"
      ".ssh"
      ".local/bin"
      ".local/share/applications"
      ".local/share/fonts"
      ".local/share/man"
      ".local/share/nix"
      ".local/state/home-manager"

      # desktop / gnome
      ".config/niri"
      ".config/dconf"
      ".cache/dconf"
      ".config/gtk-3.0"
      ".config/gtk-4.0"
      ".config/autostart"
      ".config/waypaper"
      ".local/share/color-schemes"
      ".local/share/keyrings"
      ".local/share/gnome-shell"
      ".local/share/gnome-settings-daemon"
      ".local/share/nautilus"
      ".local/share/icc"
      ".local/share/gvfs-metadata"
      ".local/share/evolution"
      ".cache/gnome-desktop-thumbnailer"
      ".cache/tracker3"
      ".cache/darkman"
      ".cache/fontconfig"
      ".cache/thumbnails"
      ".cache/libgweather"
      ".cache/geocode-glib"
      ".cache/clipboard-indicator@tudmotu.com"

      # dms
      ".config/DankMaterialShell"
      ".local/state/DankMaterialShell"
      ".cache/DankMaterialShell"
      ".config/dgop"
      ".cache/quickshell"
      ".config/cava"

      # wallpapers
      ".cache/swww"
      ".cache/waypaper"

      # shell / cli
      ".local/share/zoxide"
      ".cache/less"
      ".cache/fuzzel"
      ".config/htop"
      ".config/clipse"
      ".config/ringboard"
      ".config/television"
      ".local/share/television"
      ".cache/nix-search-tv"

      # sync
      ".cloudflared"
      ".local/state/syncthing"
      ".local/share/calendars"
      ".local/share/vdirsyncer"
      ".local/share/khal"

      # audio
      ".config/pavucontrol.ini"
      ".local/state/wireplumber"
      ".config/easyeffects"
      ".config/spotifyd"
      ".cache/spotifyd"
      ".config/spotify-player"
      ".cache/spotify-player"
      ".local/share/whisper-models"

      # graphics
      ".cache/mesa_shader_cache_db"
      ".cache/radv_builtin_shaders"
      ".cache/mesa_shader_cache"

      # dev
      ".local/share/lazygit"
      ".config/configstore"
      ".config/zed"
      ".local/share/zed"
      ".config/jiratui"
      ".config/qmk"
      ".config/composer"
      ".local/share/composer"
      ".cache/composer"
      ".npm"
      ".cache/npm"
      ".cache/pnpm"
      {
        directory = ".local/share/pnpm";
        mode = "0755";
      }
      {
        directory = ".hex";
        mode = "0755";
      }
      {
        directory = ".mix";
        mode = "0755";
      }
      {
        directory = ".cache/typescript";
        mode = "0755";
      }
      {
        directory = ".local/share/uv";
        mode = "0755";
      }
      {
        directory = ".cache/uv";
        mode = "0755";
      }
      ".cache/treefmt"
      ".cache/pre-commit"
      ".cache/nix"
      ".cache/nixpkgs-review"
      ".aws"
      ".infisical"
      ".railway"

      # ai
      ".config/github-copilot"
      ".cursor"
      ".config/Cursor"
      ".claude"
      ".local/share/claude"
      {
        directory = ".local/share/claude/versions";
        mode = "0755";
      }
      ".cache/claude-cli-nodejs"
      ".amp"
      ".config/amp"
      ".local/share/amp"
      ".cache/amp"
      {
        directory = ".config/opencode";
        mode = "0755";
      }
      {
        directory = ".local/state/opencode";
        mode = "0755";
      }
      ".local/share/opencode"
      {
        directory = ".cache/opencode";
        mode = "0755";
      }
      ".local/share/opentui" # for opencode
      ".local/share/com.pais.handy"
      ".cache/handy"
      ".happy"
      ".cache/huggingface"
      ".agents"
      ".codex"
      ".mcp-auth"
      ".aider"
      ".local/share/aider"

      # 1password
      ".config/aws"
      ".config/1Password"
      {
        directory = ".config/op";
        mode = "0700";
      }

      # flatpak / appimage
      {
        directory = ".local/share/flatpak";
        mode = "0755";
      }
      ".cache/flatpak"
      {
        directory = ".var";
        mode = "0755";
      }
      ".cache/appimage-run"

      # podman
      ".local/share/containers"

      # browsers
      ".local/share/webkitgtk-6.0"
      ".cache/epiphany"
      ".local/share/epiphany"
      ".config/net.imput.helium"

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
    ]
    ++ lib.optional config.programs.bat.enable ".cache/bat"
    ++ lib.optional config.programs.gh.enable ".config/gh"
    ++ lib.optional config.programs.ssh.enable ".cache/ssh"
    ++ lib.optional config.programs.jujutsu.enable ".config/jj"
    ++ lib.optional config.programs.starship.enable ".cache/starship"
    ++ lib.optionals config.programs.fish.enable [
      ".local/share/fish"
      ".cache/fish"
    ]
    ++ lib.optionals config.programs.vscode.enable [
      ".vscode"
      ".config/Code"
      ".local/share/vscode-beggar"
      {
        directory = ".continue";
        mode = "0755";
      }
    ]
    ++ lib.optionals config.programs.direnv.enable [
      ".cache/direnv"
      ".local/share/direnv"
    ]
    ++ lib.optionals config.programs.firefox.enable [
      ".cache/mozilla"
      ".mozilla/firefox"
    ]
    ++ lib.optionals config.programs.zen-browser.enable [
      ".cache/zen"
      ".config/zen"
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
    ++ lib.optionals config.programs.bun.enable [
      ".cache/bun"
      {
        directory = ".cache/.bun";
        mode = "0755";
      }
    ]
    ++ lib.optionals config.services.copyq.enable [
      ".config/copyq"
      ".qt_material"
      ".local/share/copyq"
    ]
    ++ lib.optionals config.services.kdeconnect.enable [
      ".config/kdeconnect"
      ".cache/kdeconnect.daemon"
    ]
    ++ [
      ".config/vivaldi"
      ".cache/vivaldi"
      ".local/lib/vivaldi"
    ]
    ++ lib.optionals config.services.activitywatch.enable [
      ".config/activitywatch"
      ".cache/activitywatch"
      ".local/share/activitywatch"
      ".config/awatcher"
    ]
    ++ lib.optional config.services.cli-proxy-api.enable ".local/share/cli-proxy-api"
    ++ [ ".config/opensnitch" ]
    ++ [ ".config/obsidian" ];
  };
}
