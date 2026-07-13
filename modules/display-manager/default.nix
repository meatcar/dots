{ nixpkgs-unstable, ... }:
{
  services.displayManager.dms-greeter = {
    enable = true;
    # must match home-manger/modules/dms/default.nix
    quickshell.package = nixpkgs-unstable.quickshell;
    # Copy the user's DMS settings (wallpaper/theme) into /var/lib/dms-greeter.
    configHome = "/home/meatcar";
    compositor.name = "niri";
    compositor.customConfig = ''
      hotkey-overlay {
          skip-at-startup
      }

      environment {
          DMS_RUN_GREETER "1"
      }

      gestures {
         hot-corners {
           off
         }
      }

      layout {
        background-color "#000000"
      }
      include optional=true "/home/meatcar/.config/niri/dms/outputs.kdl"
      include optional=true "/home/meatcar/.config/niri/dms/cursor.kdl"
    '';
  };
}
