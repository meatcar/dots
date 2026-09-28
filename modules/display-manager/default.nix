{
  inputs,
  nixpkgs-unstable,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.dank-greeter.nixosModules.default ];

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

  users.groups.dms-greeter = { };
  users.users.dms-greeter = {
    description = "DankMaterialShell greeter user";
    isSystemUser = true;
    home = "/var/lib/dms-greeter";
    homeMode = "0750";
    createHome = true;
    group = "dms-greeter";
    extraGroups = [ "video" ];
  };
  services.greetd.settings.default_session.user = "dms-greeter";
  hardware.graphics.enable = lib.mkDefault true;
  services.libinput.enable = lib.mkDefault true;

  programs.dms-greeter = {
    enable = true;
    # must match home-manager/modules/dms/default.nix
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
