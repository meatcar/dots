{ config, pkgs, ... }:
let
  xsession-wrapper =
    pkgs.runCommand "xsession-wrapper-fixed"
      {
        src = config.services.displayManager.sessionData.wrapper;
      }
      ''
        cp --preserve=mode $src $out
        substituteInPlace $out --replace "X-NIXOS-SYSTEMD-AWARE" "X-NIXOS-SYSTEMD-AWARE|niri"
      '';
in
{
  # services.displayManager.lemurs.enable = true;
  # users.users.meatcar.extraGroups = [ "seat" ];

  services.displayManager = {
    ly = {
      enable = true;
      settings = {
        save = true;
        setup_cmd = "${xsession-wrapper}";
      };
    };
  };

  # services.displayManager.gdm.enable = true;
}
