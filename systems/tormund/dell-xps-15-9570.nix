{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc"];
  boot.kernelModules = ["kvm-intel" "i915"];
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "acpi_rev_override=1"
    "acpi_osi=Linux"
    "pcie_aspm=force"
    "drm.vblankoffdelay=1"
    "nmi_watchdog=0"
  ];

  boot.blacklistedKernelModules = ["nouveau" "nv" "rivafb" "nvidiafb" "rivatv"];

  boot.extraModprobeConfig = ''
    options i915 disable_power_well=0 fastboot=1 enable_fbc=1 enable_guc=3 enable_psr=1
    options cfg80211 ieee80211_regdom=US
    options nouveau modeset=0 nouveau.runpm=0
    options scsi_mod use_blk_mq=1
  '';

  hardware.nvidia = {
    prime = {
      # sync.enable = true;
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    modesetting.enable = true;
  };

  hardware.firmware = [pkgs.wireless-regdb];

  services.hardware.bolt.enable = true;
  services.fstrim.enable = true;

  environment.systemPackages = [pkgs.libsmbios];

  hardware.pulseaudio.daemon.config = {
    "default-sample-format" = "float32le";
    "default-sample-rate" = 48000;
    "alternate-sample-rate" = 44100;
    "default-fragments" = 2;
    "default-fragment-size-msec" = 125;
    "resample-method" = "soxr-vhq";
    "realtime-priority" = 9;
  };

  console.earlySetup = true;
  # console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  networking.networkmanager.wifi.powersave = true;

  services.undervolt = {
    enable = true;
    analogioOffset = 0;
    coreOffset = -125;
    uncoreOffset = -125;
    gpuOffset = -70;
  };
  services.fprintd.tod = {
    enable = true;
    driver = pkgs.libfprint-2-tod1-goodix;
  };
}
