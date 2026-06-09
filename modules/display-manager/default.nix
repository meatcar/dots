{ nixpkgs-unstable, ... }:
{
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri"; # niri is enabled via programs.niri at the system level
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
    '';
    # Match the running shell's quickshell so the greeter gets the niri Qt null-deref fix.
    quickshell.package = nixpkgs-unstable.quickshell;
    # Copy the user's DMS settings (wallpaper/theme) into /var/lib/dms-greeter.
    configHome = "/home/meatcar";
  };
}
