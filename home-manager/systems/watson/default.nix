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
  ];

  home.packages = with pkgs; [
    vivaldi
    pciutils
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["vivaldi" "vscode"];

  programs.vscode.enable = true;
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      font-family = "Iosevka NF";
      font-size = 10;
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
    };
  };

  services.syncthing.enable = true;
  services.activitywatch.enable = true;

  home.persistence."/persist/home/meatcar" = {
    directories = [
      "Downloads"
      "Sync"
      ".ssh"
      ".local/share/gnome-shell"
    ];
    allowOther = true;
  };
}
