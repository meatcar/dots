{
  config,
  pkgs,
  ...
}: let
  gpu-on = pkgs.writeScriptBin "gpu-on" ''
    #!/bin/sh
    # mv /etc/modprobe.d/disable-nvidia.conf /etc/modprobe.d/disable-nvidia.conf.disable

    # Remove NVIDIA card (currently in power/control = auto)
    echo -n 1 > /sys/bus/pci/devices/0000\:01\:00.0/remove
    sleep 1
    # change PCIe power control
    echo -n on > /sys/bus/pci/devices/0000\:00\:01.0/power/control
    sleep 1
    # rescan for NVIDIA card (defaults to power/control = on)
    echo -n 1 > /sys/bus/pci/rescan
  '';
  gpu-off = pkgs.writeScriptBin "gpu-off" ''
    #!/bin/sh

    modprobe -r nvidia_drm
    modprobe -r nvidia_uvm
    modprobe -r nvidia_modeset
    modprobe -r nvidia

    # Change NVIDIA card power control
    echo -n auto > /sys/bus/pci/devices/0000\:01\:00.0/power/control
    sleep 1
    # change PCIe power control
    echo -n auto > /sys/bus/pci/devices/0000\:00\:01.0/power/control
    sleep 1
  '';
in {
  boot = {
    kernelParams = [
      # https://wiki.archlinux.org/index.php/Dell_XPS_15_9570#Lock-ups_when_resuming_from_suspend_with_nvidia_module
      "nouveau.blacklist=0"
    ];
    # disable nouveau from taking over at boot.
    blacklistedKernelModules = [
      "nouveau"
      "rivafb"
      "nvidiafb"
      "rivatv"
      "nv"
    ];
  };

  hardware.bumblebee = {
    enable = false;
    pmMethod = "bbswitch";
  };

  environment.systemPackages = [
    gpu-on
    gpu-off
    pkgs.glxinfo # primus
    # YUUUGE! DL on Wifi
    # pkgs.nvtop
  ];
}
