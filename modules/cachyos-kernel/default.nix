{ inputs, pkgs, ... }:
{
  imports = [
    inputs.chaotic.nixosModules.nyx-cache
    inputs.chaotic.nixosModules.nyx-overlay
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
}
