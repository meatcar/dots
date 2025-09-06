{
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    package = nixpkgs-unstable.bluez;
    powerOnBoot = true;
    # hsphfpd.enable = !config.services.pipewire.wireplumber.enable; # conflicts
    settings = {
      General = {
        ## trying to enable le audio per
        ## https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/LE-Audio-+-LC3-support
        ## but no luck so far, device connects but no audio, and flaky connection
        # ControllerMode = "le";
        # Experimental = true;
        # KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e"; # enable ISO sockets
      };
    };
  };

  services.pulseaudio = {
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  # services.blueman.enable = true;
}
