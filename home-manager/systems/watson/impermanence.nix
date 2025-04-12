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
        # ".cache/nix"
        # ".local/state/nix"
        {
          directory = ".cache/typescript";
          method = "symlink";
        }
        {
          directory = ".hex";
          method = "symlink";
        }
        {
          directory = ".mix";
          method = "symlink";
        }
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
          # seems to consume a lot of CPU as a non-symlink
          directory = ".continue";
          method = "symlink";
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
      ++ [".config/obsidian"];
  };
}
