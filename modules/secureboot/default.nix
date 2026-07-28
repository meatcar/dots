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
    configurationLimit = 20;
    pkiBundle = lib.mkDefault "/var/lib/sbctl";
  };

  # FIXME: shadow the baked-in EFI app dir
  # see https://github.com/nix-community/lanzaboote/issues/591
  systemd.services.fwupd = lib.mkIf config.services.fwupd.enable {
    serviceConfig.BindReadOnlyPaths = [
      "/run/fwupd-efi:${config.services.fwupd.package.fwupd-efi}/libexec/fwupd/efi"
    ];
  };
}
