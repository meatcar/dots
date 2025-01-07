{pkgs, ...}: {
  programs.gnome-shell.enable = true;
  programs.gnome-shell.extensions = [
    {package = pkgs.gnomeExtensions.do-not-disturb-while-screen-sharing-or-recording;}
    {package = pkgs.gnomeExtensions.dash-to-dock;}
    {package = pkgs.gnomeExtensions.appindicator;}
    {package = pkgs.gnomeExtensions.astra-monitor;}
    {package = pkgs.gnomeExtensions.bluetooth-battery-meter;}
    {package = pkgs.gnomeExtensions.caffeine;}
    {package = pkgs.gnomeExtensions.clipboard-indicator;}
    {package = pkgs.gnomeExtensions.iso8601-ish-clock;}
  ];

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
  ];
}
