{
  config,
  lib,
  ...
}:
{
  # GTK's recents list (~/.local/share/recently-used.xbel) can't be persisted
  # by symlink or bind mount -- see me.impermanence.copyPaths for why.
  me.impermanence.copyPaths.paths = [ ".local/share/recently-used.xbel" ];

  # NOTE: KConfig (QSaveFile) SILENTLY DISCARDS writes through a dangling symlink,
  # and the mkOutOfStoreSymlink targets below don't exist on first run. Pre-create
  # them after linkGeneration but before qt.kde.settings' "kconfig" writes (which
  # are only ordered after writeBoundary), so the first write lands in /persist.
  home.activation.ensureDolphinPersistTargets = lib.mkIf (config.me.fileManager == "dolphin") (
    lib.hm.dag.entryBetween [ "kconfig" ] [ "linkGeneration" ] ''
      for cfg in "$HOME/.config/dolphinrc" "$HOME/.config/kdeglobals" "$HOME/.local/state/dolphinstaterc" "$HOME/.local/share/user-places.xbel"; do
        target="$(readlink -f "$cfg")"
        if [ -n "$target" ] && [ ! -e "$target" ]; then
          run mkdir -p "$(dirname "$target")"
          run touch "$target"
        fi
      done
    ''
  );

  # NOTE: Dolphin/KDE write these via KConfig's atomic save (temp + rename), which
  # a single-file bind mount can't replace (EBUSY, impermanence#107). Symlinks are
  # safe here (unlike the GTK file above): QSaveFile resolves them first.
  home.file = lib.optionalAttrs (config.me.fileManager == "dolphin") {
    ".config/dolphinrc".source =
      config.lib.file.mkOutOfStoreSymlink "/persist${config.home.homeDirectory}/.config/dolphinrc";
    ".config/kdeglobals".source =
      config.lib.file.mkOutOfStoreSymlink "/persist${config.home.homeDirectory}/.config/kdeglobals";
    # KF6 keeps panel state in XDG_STATE_HOME, not dolphinrc; unpersisted,
    # Dolphin reopens all panels after every reboot
    ".local/state/dolphinstaterc".source =
      config.lib.file.mkOutOfStoreSymlink "/persist${config.home.homeDirectory}/.local/state/dolphinstaterc";
    # Places panel; KBookmarkManager writes via QSaveFile. Unpersisted, Dolphin
    # regenerates it from scratch and every custom entry is lost
    ".local/share/user-places.xbel".source =
      config.lib.file.mkOutOfStoreSymlink "/persist${config.home.homeDirectory}/.local/share/user-places.xbel";
  };

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
      # NOTE: recently-used.xbel and user-places.xbel don't survive single-file
      # persistence; handled by copyPaths and mkOutOfStoreSymlink above
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
      ".local/share/Trash"
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
      ".config/BeeperTexts"

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
      ".cache/cliphist"
      ".config/television"
      ".local/share/television"
      ".cache/nix-search-tv"
      {
        # gvfs.yazi's saved mount URIs carrying user/hosts
        directory = ".local/state/yazi";
        mode = "0700";
      }

      # sync
      ".cloudflared"
      ".local/state/syncthing"
      ".local/share/calendars"
      ".local/share/vdirsyncer"
      ".local/share/khal"

      # audio
      ".config/rncbc.org" # qpwgraph window/patchbay state
      ".local/state/wireplumber"
      ".config/spotifyd"
      ".cache/spotifyd" # NOTE: oauth creds, not regenerable cache -- don't demote
      ".config/spotify-player"
      ".cache/spotify-player" # NOTE: oauth creds, not regenerable cache -- don't demote
      ".local/share/whisper-models"

      # graphics
      ".cache/mesa_shader_cache_db"
      ".cache/radv_builtin_shaders"
      ".cache/mesa_shader_cache"

      # dev
      ".cache/gibo" # github/gitignore clone for `git ignore`
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
      ".paseo"
      ".cache/huggingface"
      ".agents"
      ".codex"
      ".mcp-auth"
      ".aider"
      ".local/share/aider"
      {
        directory = ".pi";
        mode = "0755";
      }
      # nono sandbox: profiles, audit trail, per-context agent state
      ".config/nono"
      ".nono"
      {
        directory = ".local/share/nono-agent-profiles";
        mode = "0700";
      }

      # 1password / agenix
      ".config/age"
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

      # wine
      {
        directory = ".local/share/bottles";
        mode = "0755";
      }

      # podman
      ".local/share/containers"
      # quadlet-nix resolves every rootless unit's ExecStart through the pivot
      # symlink ~/.config/quadlet-nix/out -> $XDG_RUNTIME_DIR/systemd/generator.
      # Unpersisted it is gone at boot and only recreated during HM activation,
      # which races the user manager's first unit load -- lose that race and
      # every quadlet unit loads stub-only ("no ExecStart"), systemd drops its
      # default.target job, and the whole stack is dead until a manual
      # `systemctl --user daemon-reload`. Persisted, the pivot is bind-mounted
      # before the session starts, so the drop-ins always resolve.
      ".config/quadlet-nix"

      # browsers
      ".local/share/webkitgtk-6.0"
      ".cache/epiphany"
      ".local/share/epiphany"
      ".config/net.imput.helium"

      # torrents
      ".config/qBittorrent"
      ".local/share/qBittorrent"
      # the tracker session the dynip jar holds outlives any one boot
      ".local/state/qbittorrent-dynip"

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

      ".local/share/garry"
    ]
    ++ lib.optional config.programs.bat.enable ".cache/bat"
    ++ lib.optionals config.programs.gh.enable [
      ".config/gh"
      # extensions ship binaries; rootfs is noexec, /persist/home isn't
      ".local/share/gh"
    ]
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
      ".config/microsoft-edge"
      ".cache/microsoft-edge"
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
    ++ lib.optional config.services.cli-proxy-api.enable ".local/share/cli-proxy-api/auth"
    # engine traits and tokens; unpersisted, the first search after a boot
    # re-bootstraps every engine and half of them time out
    ++ lib.optional config.services.searxng.enable ".cache/searxng"
    ++ lib.optional config.services.cli-proxy-api.managerPlus.enable ".local/share/cpa-manager-plus"
    ++ [ ".config/opensnitch" ]
    ++ [ ".config/obsidian" ]
    # NOTE: dolphinrc/kdeglobals persist via mkOutOfStoreSymlink above
    ++ lib.optionals (config.me.fileManager == "nautilus") [
      ".local/share/nautilus"
    ]
    ++ lib.optionals (config.me.fileManager == "dolphin") [
      ".local/share/dolphin"
      ".local/share/kxmlgui6"
      ".local/share/baloo"
    ]
    ++ lib.optionals config.services.easyeffects.enable [
      ".config/easyeffects"
    ];
  };
}
