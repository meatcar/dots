{
  pkgs,
  lib,
  config,
  nixpkgs-unstable,
  ...
}:
{
  imports = [
    ../common.nix
    ../../modules/agenix
    ../../modules/gtk.nix
    ../../modules/gnome-keyring.nix
    # ../../modules/firefox
    ../../modules/zen
    ../../modules/darkman
    ../../modules/niri
    ../../modules/1password
    ../../modules/bitwarden
    # ../../modules/docker
    ../../modules/activitywatch
    ../../modules/ghostty
    ../../modules/clipse
    ../../modules/obsidian
    ../../modules/ai
    ../../modules/vscode
    ../../modules/zed
    ../../modules/go
    ../../modules/calendar
    ../../modules/evince
    ../../modules/spotify
    ../../modules/television
    ../../modules/kdeconnect
    ../../modules/mime-apps
    ./impermanence.nix
  ];

  home.packages =
    with pkgs;
    [
      pciutils
      code-cursor
      calibre
      gimp
      inkscape
      loupe
      pantheon.epiphany
    ]
    ++ (with nixpkgs-unstable; [
      vivaldi-ffmpeg-codecs
      widevine-cdm
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
      })
    ]);

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vivaldi"
      "vscode"
    ];

  programs.chromium.enable = true;

  services.syncthing.enable = true;
  services.easyeffects.enable = true;
  home.file."/git".source = config.lib.file.mkOutOfStoreSymlink "/git";
}
