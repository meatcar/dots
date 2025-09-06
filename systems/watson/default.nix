{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
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
    ../../modules/fc660c-hasu
    ../../modules/backup
    ../../modules/laptop
    ../../modules/nix-ld
    ../../modules/resolved
    ../../modules/geoclue
    ../../modules/pipewire
    ../../modules/bluetooth
    ../../modules/display-manager
    # ../../modules/displaylink
    ../../modules/keyd
    ../../modules/podman
    ../../modules/fingerprint
    ../../modules/1password
    ../../modules/printing
    # ../../modules/opensnitch
    ../../modules/steam
    ../../modules/vm
    ./t14s-micmuteled.nix
  ];
  system.stateVersion = "25.11";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "video=DP-8:2560x1440@60"
    "video=HDMI-A-2:3840x2160@60"
  ];
  boot.initrd.availableKernelModules = [
    "thunderbolt"
    "amdgpu"
  ];

  hardware.graphics.extraPackages = [
    pkgs.rocmPackages.clr.icd
    pkgs.rocmPackages.rocm-smi
  ];
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
    perf
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
    22000 # for syncthing
  ];

  networking.firewall.allowedUDPPorts = [
    22000 # for syncthing
    21027 # for syncthing discovery
  ];
  networking.hosts = {
    # FIX: for https://github.com/Spotifyd/spotifyd/issues/1358
    "0.0.0.0" = [ "apresolve.spotify.com" ];
  };

  time.timeZone = lib.mkDefault "Canada/Eastern";
  services.automatic-timezoned.enable = true;

  programs.niri.enable = true;

  services.tailscale = {
    enable = false;
    # FIX: for https://github.com/NixOS/nixpkgs/issues/438765
    package = nixpkgs-unstable.tailscale;
  };

  services.syncthing.enable = false; # prefer HM module
  services.flatpak.enable = true;

  services.languagetool.enable = true;

  programs.kdeconnect.enable = true;

  environment.enableAllTerminfo = lib.mkForce false;

  # for nautilus
  environment.pathsToLink = [
    "/share/nautilus-python/extensions"
  ];
  # programs.hyprland.enable = true;
  # we manage this in HM
  systemd.user.services.niri-flake-polkit.enable = false;

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
      "dialout"
    ];
  };
}
