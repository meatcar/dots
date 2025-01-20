{pkgs, ...}: {
  programs.gnome-shell.enable = true;
  programs.gnome-shell.extensions = builtins.map (p: {package = p;}) (with pkgs.gnomeExtensions; [
    do-not-disturb-while-screen-sharing-or-recording
    dash-to-dock
    appindicator
    astra-monitor
    bluetooth-battery-meter
    caffeine
    clipboard-indicator
    iso8601-ish-clock
    focused-window-d-bus
    smile-complementary-extension
    battery-time
  ]);

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

  home.packages = [
    (pkgs.writeShellScriptBin "get-theme" ''
      ${pkgs.dconf}/bin/dconf read /org/gnome/desktop/interface/color-scheme | tr -d "'" | sed 's/^prefer-//'
    '')
    pkgs.smile
    pkgs.wl-clipboard
  ];
}
