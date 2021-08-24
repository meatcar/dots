{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/cachix.nix
    ../modules/nix.nix
    ../modules/networking.nix
    ../modules/bluetooth.nix
    ../modules/keyring.nix
    ../modules/intel.nix
    ../modules/nvidia
    ../modules/power
    # ../modules/steam.nix
    ../modules/egpu
    ../modules/dualboot.nix
    # ../modules/ly.nix
    ./user.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "resume"
      "resume_offset=267520"
      "mem_sleep_default=deep"
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

    cleanTmpDir = true;
  };

  hardware = {
    opengl.enable = true;
    pulseaudio.enable = true;
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

  system.stateVersion = "20.03";
  networking.hostName = "tormund";
  time.timeZone = "America/Toronto";
  location.provider = "geoclue2";

  services = {
    gnome.gnome-settings-daemon.enable = true;
  };

  services.dbus.packages = [ pkgs.gnome3.dconf ];

  fonts = {
    fontconfig = {
      enable = lib.mkOptionDefault true;
      defaultFonts = {
        monospace = [ "GoMono Nerd Font" ];
        sansSerif = [ "Inter" ];
        serif = [ "Liberation Serif" ];
      };
    };
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = builtins.attrValues {
      inherit (pkgs)
        # icons
        font-awesome_4
        # proportional
        google-fonts
        inter
        # monospace
        #dina-font fira-code-symbols
        #iosevka ibm-plex go-font fira-code
        go-font
        emacs-all-the-icons-fonts
        ;
      nerdfonts = pkgs.nerdfonts.override {
        fonts = [ "Go-Mono" ];
      };
    };
  };
  gtk.iconCache.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };

  xdg = {
    icons.enable = true;
    mime.enable = true;
    menus.enable = true;
    portal.enable = true;
    portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    sounds.enable = true;
  };
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) vim git pciutils usbutils bind nix-prefetch-git brightnessctl;
    inherit (pkgs)
      glib
      xwayland swaybg swayidle swaylock
      mako
      grim slurp
      wl-clipboard
      light
      gtk2fontsel
      libnotify
      inotify-tools# for waybar

      # File Management
      xdg_utils
      fuse_exfat
      exfat-utils
      ntfs3g
      hicolor-icon-theme
      breeze-icons
      imv
      zathura
      streamlink
      chromium
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
      pkgs: [ pkgs.youtube-dl ]
    );
    # spotify
    inherit (pkgs) spotifyd spotify-tui;
  };

  programs = {
    sway.enable = false;

    gnome-disks.enable = true;

    fish.enable = true;
    zsh.enable = true;
  };
}
