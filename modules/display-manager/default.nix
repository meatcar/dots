{
  nixpkgs-unstable,
  pkgs,
  lib,
  config,
  ...
}:
{
  # Shadows the niri package's niri-session (hiPrio wins the profile merge)
  # to recover from an orphaned niri.service instead of locking out login.
  environment.systemPackages = [
    (lib.hiPrio (
      pkgs.writeShellApplication {
        name = "niri-session";
        runtimeInputs = [
          pkgs.systemd
          pkgs.coreutils # tee
          config.programs.niri.package
        ];
        text = builtins.readFile ./niri-session-unorphan.sh;
      }
    ))
  ];

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
      // FIXME: don't include ~/.config/niri/dms/outputs.kdl here: it's stale
      // at greeter time and can disable the only connected output (black
      // screen when booting undocked).
      include optional=true "/home/meatcar/.config/niri/dms/cursor.kdl"
    '';
  };
}
