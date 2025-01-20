{
  config,
  pkgs,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
    powerOnBoot = false;
    hsphfpd.enable = !config.services.pipewire.wireplumber.enable; # conflicts
  };

  hardware.pulseaudio = {
    extraModules = [pkgs.pulseaudio-modules-bt];
    package = pkgs.pulseaudioFull;
  };

  services.blueman.enable = true;
}
