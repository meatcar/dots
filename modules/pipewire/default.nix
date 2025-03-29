{pkgs, ...}: {
  # security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    # alsa.enable = true;
    # alsa.support32Bit = true;
    # jack.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-rename-laptop-devices.conf" ''
        monitor.alsa.rules = [
          {
            matches = [{ node.name = "alsa_output.pci-0000_c3_00.6.HiFi__Speaker__sink" }]
            actions = { update-props = { node.description = "Laptop Speakers" } }
          },
          {
            matches = [{ node.name = "alsa_input.pci-0000_c3_00.6.HiFi__Mic2__source" }]
            actions = { update-props = { node.description = "Laptop Headphones Microphone" } }
          },
          {
            matches = [{ node.name = "alsa_input.pci-0000_c3_00.6.HiFi__Mic1__source" }]
            actions = { update-props = { node.description = "Laptop Microphone" } }
          }
        ]
      '')
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-rename-usb.conf" ''
        monitor.alsa.rules = [
          {
            matches = [{ node.name = "alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo" }]
            actions = { update-props = { node.description = "USB Headphones" } }
          },
          {
            matches = [{ node.name = "alsa_input.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.mono-fallback" }]
            actions = { update-props = { node.description = "USB Microphone" } }
          },
        ]
      '')
    ];
  };
}
