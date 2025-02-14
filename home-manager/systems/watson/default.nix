{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ../common.nix
    ../../modules/gtk.nix
    ../../modules/gnome-keyring.nix
    ../../modules/firefox
    ../../modules/gnome-shell
    ../../modules/1password
    ../../modules/docker
    ../../modules/activitywatch
    ../../modules/ghostty
    ../../modules/obsidian
    ../../modules/vscode
    ./impermanence.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    pciutils
    aider-chat
    code-cursor
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["vivaldi" "vscode"];

  programs.chromium.enable = true;

  services.syncthing.enable = true;
  home.file."/git".source = config.lib.file.mkOutOfStoreSymlink "/git";
}
