{
  pkgs,
  ...
}:
let
  env = {
    # FIXME: blocked by https://github.com/NixOS/nixpkgs/issues/382612
    # NIXOS_OZONE_WL = "1"; # hint chromium/electron to not use XWayland
    # ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = 1;
    _JAVA_AWT_WM_NONREPARENTING = "1";
    SDL_VIDEODRIVER = "wayland";
  };
in
{
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
  };
}
