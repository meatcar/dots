{ config, pkgs, ... }:
{
  home.packages = [ pkgs.kanshi ];
  xdg.configFile."kanshi/config" = {
    onChange = "pkill kanshi && swaymsg exec kanshi";
    text = ''
      profile all {
        output "*" enable
      }

      profile samsung {
        output eDP-1 disable
        output "Samsung Electric Company C27JG5x H4ZN100219" position 0,0
      }

      profile lg {
        output eDP-1 position 0,1440
        output "Goldstar Company Ltd LG HDR WFHD 0x0000DB2B" position 0,0
      }
    '';
  };

  wayland.windowManager.sway.config.startup = [
    {
      always = true;
      command = "${pkgs.kanshi}/bin/kanshi";
    }
  ];
}
