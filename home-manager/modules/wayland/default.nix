{pkgs, ...}: {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # hint chromium/electron to not use XWayland
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland";
  };
  home.packages = [
    pkgs.wl-clipboard
  ];

  services.darkman = {
    enable = true;
    settings = {
      usegeoclue = true;
    };
  };
}
