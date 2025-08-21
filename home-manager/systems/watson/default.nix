{
  pkgs,
  lib,
  config,
  specialArgs,
  ...
}:
{
  imports = [
    ../common.nix
    ../../modules/agenix
    ../../modules/gtk.nix
    ../../modules/gnome-keyring.nix
    ../../modules/firefox
    ../../modules/darkman
    ../../modules/niri
    # ../../modules/hyperland
    ../../modules/1password
    # ../../modules/docker
    ../../modules/activitywatch
    ../../modules/ghostty
    ../../modules/obsidian
    ../../modules/ai
    ../../modules/vscode
    ../../modules/zed
    ../../modules/go
    ../../modules/calendar
    ../../modules/evince
    ../../modules/spotify
    ../../modules/television
    ../../modules/centerpiece
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
    ++ (with specialArgs.nixpkgs-unstable; [
      vivaldi
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
  services.opensnitch-ui.enable = true;
  services.easyeffects.enable = false; # true; TODO: causes shutdown to be slow
  home.file."/git".source = config.lib.file.mkOutOfStoreSymlink "/git";
}
