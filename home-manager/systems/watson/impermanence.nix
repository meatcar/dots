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
      ".claude.json"
      ".clasprc.json" # for clasp gscript upload tool
    ];
    directories = [
      # ".cache/nix"
      # ".local/state/nix"
      ".config/niri"
      {
        directory = ".cache/typescript";
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
        directory = ".config/opencode";
        mode = "0755";
      }
      {
        directory = ".local/state/opencode";
        mode = "0755";
      }
      ".local/share/opentui" # for opencode
      {
        directory = ".local/share/pnpm";
        mode = "0755";
      }
      ".local/share/lazygit"
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
      ".zen"
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
    ++ [ ".config/opensnitch" ]
    ++ [ ".config/obsidian" ];
  };
}
