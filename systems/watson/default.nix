{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ../../modules/hardware/thinkpad_trackpoint_keyboard_ii.nix
    ../common.nix
    ../../modules/impermanence
    ../../modules/secureboot
    # ../../modules/ddcci
    ../../modules/laptop
    ../../modules/resolved
    ../../modules/geoclue
    ../../modules/pipewire
    ../../modules/bluetooth
    ../../modules/display-manager
    # ../../modules/displaylink
    ../../modules/keyd
    ../../modules/podman.nix
    ../../modules/fingerprint.nix
    ../../modules/1password
    ../../modules/printing
    # ../../modules/opensnitch
    ../../modules/steam
    ./t14s-micmuteled.nix
  ];
  system.stateVersion = "24.11";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  # TODO: linux 6.13 causes bug. Wait for resolution.
  # https://gitlab.freedesktop.org/drm/amd/-/issues/3697
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # hardware.graphics.extraPackages = [
  #   pkgs.rocmPackages.clr.icd
  #   pkgs.amdvlk
  # ];
  # hardware.graphics.extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  # environment.variables.AMD_VULKAN_ICD = "RADV";
  #
  boot.initrd.systemd = {
    # for hibernation, tpm2 luks unlock
    enable = true;

    storePaths = [
      "${config.boot.initrd.systemd.package}/lib/systemd/systemd-tpm2-setup"
      "${config.boot.initrd.systemd.package}/lib/systemd/system-generators/systemd-tpm2-generator"
    ];
  };
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  systemd.enableEmergencyMode = false;

  # if you're not going to work reliably, don't work at all.
  # boot.plymouth.enable = true;

  systemd.services.t14-hibernate-pre = {
    description = "T14s Gen4 Hibernate Tweak (pre)";
    before = [ "hibernate.target" ];
    wantedBy = [ "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [ "/run/current-system/sw/sbin/rmmod ath11k_pci" ];
    };
  };

  systemd.services.t14-hibernate-post = {
    description = "T14s Gen4 Hibernate Tweak (post)";
    after = [ "hibernate.target" ];
    wantedBy = [ "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [ "/run/current-system/sw/sbin/modprobe ath11k_pci" ];
    };
  };

  services.t14-micmuteled.enable = true;

  networking.hostName = "watson"; # Define your hostname.
  networking.nameservers = [
    "8.8.8.8#dns.google"
    "1.1.1.1#cloudflare-dns.com"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    wget

    efibootmgr
    usbutils
    radeontop
    v4l-utils
    config.boot.kernelPackages.perf
  ];

  services.fwupd.enable = true;
  systemd.timers.fwupd-refresh.enable = false; # https://github.com/NixOS/nixpkgs/issues/271834

  services.hardware.bolt.enable = true;
  services.gnome.gnome-keyring.enable = true;
  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
  };

  networking.firewall.allowedTCPPorts = [
    57621 # for spotify
    5353 # for chromecast
  ];

  time.timeZone = lib.mkDefault "Canada/Eastern";
  services.automatic-timezoned.enable = true;

  programs.niri.enable = true;

  services.tailscale.enable = true;
  services.syncthing = {
    enable = false;
    openDefaultPorts = true;
  };
  services.flatpak.enable = true;

  environment.enableAllTerminfo = lib.mkForce false;

  # for nautilus
  environment.pathsToLink = [
    "/share/nautilus-python/extensions"
  ];
  # programs.hyprland.enable = true;

  nix.settings.trusted-users = [ "meatcar" ];
  users.mutableUsers = false;
  users.users.meatcar = {
    isNormalUser = true;
    useDefaultShell = false;
    shell = "${pkgs.fish}/bin/fish";
    # nix-shell -p mkpasswd --command 'mkpasswd -m sha-512'
    hashedPassword = "$6$d60LJzot5J$PeWx9sU6rPNEy39uSewpJiV5CfOh9McENT5Crl4WCFyvwL/5jyH7Jn2pENG6pEWPNNFl2Xnp4WGEJEMAU2Mym0";
    extraGroups = [
      "wheel"
      "docker"
    ];
  };
}
