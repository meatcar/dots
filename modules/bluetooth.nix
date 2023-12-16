{
  config,
  pkgs,
  ...
}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = false;
    hsphfpd.enable = true;
  };

  hardware.pulseaudio = {
    extraModules = [pkgs.pulseaudio-modules-bt];
    package = pkgs.pulseaudioFull;
  };

  services.blueman.enable = true;
}
