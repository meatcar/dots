{ pkgs, ... }:
{
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 6500;
      night = 4200;
    };
    tray = true;
  };
}
