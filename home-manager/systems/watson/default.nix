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
    ./impermanence.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    pciutils
    albert
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["vivaldi" "vscode" "albert"];

  programs.vscode.enable = true;
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      font-family = "Iosevka Nerd Font";
      font-size = 10;
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
    };
  };
  programs.chromium.enable = true;

  services.syncthing.enable = true;
  home.file."/git".source = config.lib.file.mkOutOfStoreSymlink "/git";
}
