{
  pkgs,
  ...
}:
let
  env = {
    NIXOS_OZONE_WL = "1"; # hint chromium/electron to not use XWayland
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = 1;
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # FIXME: disabled for now, breaks some apps
    # SDL_VIDEODRIVER = "wayland";
  };
in
{
  imports = [
    ../ringboard
  ];
  home.sessionVariables = env;
  systemd.user.sessionVariables = env;
  home.packages = [
    pkgs.wl-clipboard
  ];

  services.darkman = {
    enable = true;
    settings = {
      usegeoclue = true;
    };
    darkModeScripts = {
      brightness = "${pkgs.swayosd}/bin/swayosd-client --brightness 50";
    };
    lightModeScripts = {
      brightness = "${pkgs.swayosd}/bin/swayosd-client --brightness 100";
    };
  };
}
