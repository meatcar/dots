{pkgs, ...}: {
  # security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    # alsa.enable = true;
    # alsa.support32Bit = true;
    # jack.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
        monitor.bluez.properties = {
          bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
          bluez5.codecs = [ sbc sbc_xq aac aptx aptx_hd aptx_ll opus_05 ]
          bluez5.enable-sbc-xq = true
          bluez5.enable-msbc = true
          bluez5.enable-hw-volume = true
          bluez5.hfphsp-backend = "native"
        }
      '')
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
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-disable-devices.conf" ''
        monitor.alsa.rules = [
          {
            matches = [
              { node.name = "alsa_output.pci-0000_07_00.1.HiFi__HDMI1__sink" },
              { node.name = "alsa_output.pci-0000_07_00.1.HiFi__HDMI2__sink" },
              { node.name = "alsa_output.pci-0000_07_00.1.HiFi__HDMI3__sink" },
              { node.name = "alsa_output.pci-0000_07_00.1.HiFi__HDMI4__sink" },
              { node.name = "alsa_output.pci-0000_07_00.1.HiFi__HDMI5__sink" },
              { node.name = "alsa_output.pci-0000_07_00.1.HiFi__HDMI6__sink" }
            ]
            actions = { update-props = { devices.disabled = true} }
          },
        ]
      '')
    ];
  };
}
