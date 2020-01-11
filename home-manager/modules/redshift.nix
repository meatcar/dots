{ pkgs, ... }:
{
  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
    provider = "geoclue2";
    temperature = {
      day = 6500;
      night = 4200;
    };
  };
}
