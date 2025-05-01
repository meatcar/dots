{
  pkgs,
  lib,
  ...
}: let
  DISPLAY = ":0";
in {
  imports = [
    ../wayland
    ../waybar
    ../fuzzel
    ../gammastep.nix
    ../swaync
    ../nautilus
  ];
  home.packages = with pkgs; [
    swaylock
    fuzzel
  ];
  services.gnome-keyring.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.niri];
  };
  services.swayosd.enable = true;
  services.copyq.enable = true;
  wayland.windowManager.hyperland = {
    enable = true;
    systemd.variables = ["--all"];
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Enter, exec, ghostty"
        "$mod, P, exec, fuzzel"
      ];
    };
  };
}
