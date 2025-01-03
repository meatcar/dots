{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common.nix
    ../../modules/gtk.nix
    ../../modules/gnome-keyring.nix
    ../../modules/firefox
  ];

  home.packages = with pkgs; [
    vivaldi
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["vivaldi" "vscode"];

  services.syncthing.enable = true;
  services.activitywatch.enable = true;
  services.darkman = {
    enable = true;
    darkModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      '';
    };
    lightModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      '';
    };
    settings = {
      usegeoclue = true;
    };
  };

  programs.firefox.package = pkgs.firefox.override {
    # See nixpkgs' firefox/wrapper.nix to check which options you can use
    nativeMessagingHosts = [
      # Gnome shell native connector
      pkgs.gnome-browser-connector
    ];
  };

  programs.vscode.enable = true;
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      font-size = 10;
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
    };
  };

  home.persistence."/persist/home/meatcar" = {
    directories = [
      "Downloads"
      "Sync"
      ".ssh"
    ];
    allowOther = true;
  };
}
