{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ../common.nix
    ../../modules/impermanence
    ../../modules/secureboot
    ../../modules/laptop
    ../../modules/geoclue
    ../../modules/pipewire
    ../../modules/bluetooth
    ../../modules/display-manager
    ../../modules/keyd
    ../../modules/podman.nix
    ../../modules/fingerprint.nix
    ../../modules/1password
    ../../modules/printing
    ./t14s-micmuteled.nix
  ];
  system.stateVersion = "24.11";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  # TODO: linux 6.13 causes bug. Wait for resolution.
  # https://gitlab.freedesktop.org/drm/amd/-/issues/3697
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.systemd = {
    # for hibernation, tpm2 luks unlock
    enable = true;

    # additionalUpstreamUnits = ["systemd-tpm2-setup-early.service"];
    storePaths = [
      "${config.boot.initrd.systemd.package}/lib/systemd/systemd-tpm2-setup"
      "${config.boot.initrd.systemd.package}/lib/systemd/system-generators/systemd-tpm2-generator"
    ];
  };
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;

  # if you're not going to work reliably, don't work at all.
  # boot.plymouth.enable = true;

  systemd.services.t14-hibernate-pre = {
    description = "T14s Gen4 Hibernate Tweak (pre)";
    before = ["hibernate.target"];
    wantedBy = ["hibernate.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ["/run/current-system/sw/sbin/rmmod ath11k_pci"];
    };
  };

  systemd.services.t14-hibernate-post = {
    description = "T14s Gen4 Hibernate Tweak (post)";
    after = ["hibernate.target"];
    wantedBy = ["hibernate.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ["/run/current-system/sw/sbin/modprobe ath11k_pci"];
    };
  };

  services.t14-micmuteled.enable = true;

  networking.hostName = "watson"; # Define your hostname.
  networking.nameservers = [
    "8.8.8.8#dns.google"
    "1.1.1.1#cloudflare-dns.com"
  ];
  services.resolved = {
    enable = true;
    dnsovertls = "true";
  };
  # FIX for https://github.com/systemd/systemd/issues/35654
  systemd.services.systemd-resolved = {
    wantedBy = ["network-online.target"];
    after = ["network-online.target"];
    partOf = ["network-online.target"];
  };

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

  services.opensnitch.enable = true;
  services.tailscale.enable = true;


  # for nautilus
  environment.pathsToLink = [
    "/share/nautilus-python/extensions"
  ];

  nix.settings.trusted-users = ["meatcar"];
  users.mutableUsers = false;
  users.users.meatcar = {
    isNormalUser = true;
    useDefaultShell = false;
    shell = "${pkgs.fish}/bin/fish";
    # nix-shell -p mkpasswd --command 'mkpasswd -m sha-512'
    hashedPassword = "$6$d60LJzot5J$PeWx9sU6rPNEy39uSewpJiV5CfOh9McENT5Crl4WCFyvwL/5jyH7Jn2pENG6pEWPNNFl2Xnp4WGEJEMAU2Mym0";
    extraGroups = ["wheel" "docker"];
  };
}
