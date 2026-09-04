{ lib, pkgs, ... }:
let
  # FIXME: alsa-ucm-conf hides HDA HDMI PCM device 10 (the eGPU TV port) and
  # gates HDMI-only HDA cards' UCM on the ACP card being readable, which races
  # logind's login ACLs. Patching the package rebuilds the audio world, so ship
  # a corrected tree and point alsa-lib at it. See alsa-ucm-hdmi-fix.sh.
  # https://github.com/alsa-project/alsa-ucm-conf/blob/master/ucm2/codecs/hda/hdmi.conf#L15
  alsa-ucm-conf-fixed = pkgs.runCommand "alsa-ucm-conf-hdmi-fix" {
    UCM_SRC = "${pkgs.alsa-ucm-conf}/share/alsa/ucm2";
  } (builtins.readFile ./alsa-ucm-hdmi-fix.sh);
in
{
  # security.rtkit.enable = true;

  # units ship with the pipewire package, so extend rather than replace them
  systemd.user.services = lib.genAttrs [ "pipewire" "wireplumber" ] (_: {
    overrideStrategy = "asDropin";
    environment.ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-fixed}";
  });

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    # jack.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
        monitor.bluez.properties = {
          bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
          bluez5.codecs = [ sbc sbc_xq aac aptx aptx_hd aptx_ll opus_05 lc3 ldac ]
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
      # eGPU HDMI/DP outputs. The eGPU PCI address is not stable across hotplug,
      # so match on card name and ELD-derived alsa.name, and pin node.name:
      # WirePlumber keys the remembered default, volume and route on it. Only the
      # TV gets audio; hide the C27JG5x and the portless outputs (no ELD, generic
      # "HDMI <n>" name).
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-rename-hdmi.conf" ''
        monitor.alsa.rules = [
          {
            matches = [
              {
                alsa.card_name = "HDA ATI HDMI"
                alsa.name = "LG TV SSCR2"
              }
            ]
            actions = {
              update-props = {
                node.name = "egpu-tv"
                node.description = "eGPU LG TV"
              }
            }
          }
          {
            matches = [
              {
                alsa.card_name = "HDA ATI HDMI"
                alsa.name = "C27JG5x"
              }
              {
                alsa.card_name = "HDA ATI HDMI"
                alsa.name = "~HDMI [0-9]+"
              }
            ]
            actions = { update-props = { node.disabled = true } }
          }
        ]
      '')
    ];
  };
}
