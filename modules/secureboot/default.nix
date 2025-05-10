{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Make tpm kernel modules available in the initrd
  boot.initrd.availableKernelModules = [
    "tpm-crb"
    "tpm-tis"
  ];

  # Install fido2, sbctl, and tpm packages
  environment.systemPackages = with pkgs; [
    libfido2
    sbctl
    tpm2-tools
    tpm2-tss
  ];

  # Ensure bootspec is enabled
  boot.bootspec.enable = lib.mkDefault true;

  # Lanzaboote replaces the systemd-boot module
  boot.loader.systemd-boot.enable = lib.mkForce (!config.boot.lanzaboote.enable);

  # Configure lanzaboote for secureboot
  boot.lanzaboote = {
    enable = lib.mkDefault true;
    configurationLimit = 5;
    pkiBundle = lib.mkDefault "/var/lib/sbctl";
  };
}
