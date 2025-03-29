{pkgs, ...}: {
  imports = [../wayland];
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
    focused-window-d-bus # for awatcher https://github.com/2e3s/awatcher?tab=readme-ov-file#user-content-fn-4-f18d6f5c4c9abfe4b35ead5fb5b50e46
    smile-complementary-extension
    auto-move-windows
    quick-settings-audio-devices-renamer
    quick-settings-audio-devices-hider
    toggle-headphone
  ]);

  programs.firefox.package = pkgs.firefox.override {
    # See nixpkgs' firefox/wrapper.nix to check which options you can use
    nativeMessagingHosts = [
      # Gnome shell native connector
      pkgs.gnome-browser-connector
    ];
  };

  home.packages = [
    pkgs.smile
  ];
}
