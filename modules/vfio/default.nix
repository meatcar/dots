{
  config,
  pkgs,
  ...
}: {
  boot.kernelParams = ["amd_iommu=on" "intel_iommu=on" "iommu=1" "rd.driver.pre=vfio-pci"];
  boot.kernelModules = ["kvm-intel" "tap" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio"];
  boot.extraModprobeConfig = "options vfio-pci ids=8086:3e9b,10de:1c8c,1002:ab38"; # Intel,Nvidia,AMD

  environment.systemPackages = [
    pkgs.virt-manager
    pkgs.looking-glass-client
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu_kvm;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 meatcar qemu-libvirtd -"
    "f /dev/shm/scream 0660 meatcar qemu-libvirtd -"
  ];

  systemd.user.services.scream-ivshmem = {
    enable = true;
    description = "Scream IVSHMEM";
    serviceConfig = {
      ExecStart = "${pkgs.scream-receivers}/bin/scream-ivshmem-pulse /dev/shm/scream";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
    requires = ["pulseaudio.service"];
  };
}
