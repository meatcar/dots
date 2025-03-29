{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ../common.nix
    ../../modules/agenix
    ../../modules/gtk.nix
    ../../modules/gnome-keyring.nix
    ../../modules/firefox
    ../../modules/darkman
    ../../modules/niri
    ../../modules/1password
    # ../../modules/docker
    ../../modules/activitywatch
    ../../modules/ghostty
    ../../modules/obsidian
    ../../modules/vscode
    ../../modules/aider
    ../../modules/zed
    ../../modules/calendar
    ../../modules/evince
    ./impermanence.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    pciutils
    code-cursor
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["vivaldi" "vscode"];

  programs.chromium.enable = true;

  services.syncthing.enable = true;
  services.opensnitch-ui.enable = true;
  home.file."/git".source = config.lib.file.mkOutOfStoreSymlink "/git";
}
