{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ../common.nix
    ../../modules/impermanence
    ../../modules/secureboot
    ../../modules/power
    ../../modules/geoclue
    ../../modules/gnome
    ../../modules/docker.nix
    ../../modules/fingerprint.nix
    ./t14s-micmuteled.nix
  ];
  system.stateVersion = "24.11";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

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

  networking.hostName = "watson"; # Define your hostname.
  networking.networkmanager.enable = true;
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget

    efibootmgr
    radeontop
    v4l-utils
  ];

  zramSwap.enable = true;
  services.fwupd.enable = true;
  systemd.timers.fwupd-refresh.enable = false; # https://github.com/NixOS/nixpkgs/issues/271834
  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
  };

  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["meatcar"];

  services.t14-micmuteled.enable = true;

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
