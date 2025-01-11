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
    ./impermanence.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    pciutils
    albert
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["vivaldi" "vscode" "albert"];

  programs.vscode.enable = true;
  programs.chromium.enable = true;

  services.syncthing.enable = true;
  home.file."/git".source = config.lib.file.mkOutOfStoreSymlink "/git";
}
