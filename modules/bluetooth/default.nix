{
  pkgs,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
    powerOnBoot = true;
    # hsphfpd.enable = !config.services.pipewire.wireplumber.enable; # conflicts
  };

  services.pulseaudio = {
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  services.blueman.enable = true;
}
