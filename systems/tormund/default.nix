{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./dell-xps-15-9570.nix
    ./hardware-configuration.nix
    ./../common.nix
    ./user.nix
    ../../modules/keyring.nix
    ../../modules/networking.nix
    ../../modules/pipewire.nix
    ../../modules/bluetooth.nix
    ../../modules/intel.nix
    ../../modules/nvidia
    ../../modules/power
    ../../modules/steam.nix
    ../../modules/egpu
    ../../modules/dualboot.nix
    ../../modules/ly.nix
    ../../modules/docker.nix
    # ../../modules/fingerprint.nix
  ];

  system.stateVersion = "20.03";
  networking.hostName = "tormund";
  time.timeZone = "America/Toronto";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "resume"
      "resume_offset=267520"
    ];
    resumeDevice = "/dev/mapper/cryptroot";
    kernel.sysctl = {"vm.swappiness" = lib.mkDefault 1;};

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "auto";
        editor = false;
      };
    };

    cleanTmpDir = true;
  };

  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    btrfs.autoScrub = {
      enable = true;
      fileSystems = ["/"];
    };
    logind = {
      lidSwitch = "hybrid-sleep";
      lidSwitchDocked = "hybrid-sleep";
      extraConfig = ''
        HandlePowerKey=hybrid-sleep
        RuntimeDirectorySize=3G
      '';
    };
    printing.enable = true;
  };

  location.provider = "geoclue2";

  services.gnome.gnome-settings-daemon.enable = true;

  services.dbus.packages = [pkgs.gnome3.dconf];

  programs = {
    sway.enable = false;
    gnome-disks.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) vim git pciutils usbutils bind nix-prefetch-git brightnessctl;
    inherit
      (pkgs)
      glib
      xwayland
      swaybg
      swayidle
      swaylock
      mako
      grim
      slurp
      wl-clipboard
      light
      gtk2fontsel
      libnotify
      inotify-tools # for waybar
      
      # File Management
      
      xdg-utils
      fuse_exfat
      exfat-utils
      ntfs3g
      hicolor-icon-theme
      breeze-icons
      imv
      zathura
      streamlink
      google-chrome
      qbittorrent
      # audio
      
      pavucontrol
      ncpamixer
      mps-youtube
      youtube-dl
      ;
    # dwarf-fortress-full = (pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
    #   enableTextMode = true;
    #   theme = "cla";
    # });
    inherit (pkgs.xfce) thunar thunar-archive-plugin tumbler;
    inherit (pkgs) waybar;
    inherit (pkgs.gnome2) gnome_icon_theme;
    inherit (pkgs.gnome3) adwaita-icon-theme;
    python3 = pkgs.python3.withPackages (
      pkgs: [pkgs.youtube-dl]
    );
    # spotify
    inherit (pkgs) spotifyd spotify-tui;
  };
}
