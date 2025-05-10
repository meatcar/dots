{
  pkgs,
  lib,
  ...
}:
{
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
    kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 1;
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "auto";
        editor = false;
      };
    };

    tmp.cleanOnBoot = true;
  };

  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
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

  services.dbus.packages = [ pkgs.dconf ];

  programs = {
    sway.enable = false;
    gnome-disks.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      vim
      git
      pciutils
      usbutils
      bind
      nix-prefetch-git
      brightnessctl
      ;
    inherit (pkgs)
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
      libnotify
      inotify-tools # for waybar

      # File Management
      xdg-utils
      exfat
      exfatprogs
      ntfs3g
      # themes
      hicolor-icon-theme
      gnome-icon-theme
      breeze-icons
      imv
      zathura
      streamlink
      google-chrome
      qbittorrent
      adwaita-icon-theme
      # audio
      pavucontrol
      ncpamixer
      yewtube
      yt-dlp
      ;
    # dwarf-fortress-full = (pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
    #   enableTextMode = true;
    #   theme = "cla";
    # });
    inherit (pkgs.xfce) thunar thunar-archive-plugin tumbler;
    inherit (pkgs) waybar;
    # spotify
    inherit (pkgs) spotifyd;
  };
}
