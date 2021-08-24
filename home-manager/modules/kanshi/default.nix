{ config, pkgs, ... }:
{
  services.kanshi = {
    enable = true;
    profiles = {
      all = {
        outputs = [{ criteria = "*"; status = "enable"; }];
      };
      samsung = {
        exec = "${pkgs.sway}/bin/swaymsg workspace 1, move workspace to DP-6";
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,650";
          }
          {
            criteria = "Samsung Electric Company C27JG5x H4ZN100219";
            status = "enable";
            position = "1920,0";
            mode = "2560x1440@144Hz";
          }
        ];
      };
      lg = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,1440";
          }
          {
            criteria = "Goldstar Company Ltd LG HDR WFHD 0x0000DB2B";
            status = "enable";
            position = "0,0";
          }
        ];
      };
    };
  };
}
