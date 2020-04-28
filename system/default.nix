{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/nix.nix
    ../modules/networking.nix
    ../modules/bluetooth.nix
    ../modules/keyring.nix
    ../modules/intel.nix
    ../modules/nvidia
    ../modules/power
    # ../modules/ly.nix
    ./user.nix
  ];

  # TODO: pull out into modules
  nixpkgs.overlays =
    let
      nixpkgs-wayland = import config.niv.nixpkgs-wayland;
    in
      [ nixpkgs-wayland ];

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
    enableRedistributableFirmware = true;
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

  system.stateVersion = "19.09";
  networking.hostName = "tormund.denys.me";
  time.timeZone = "America/Toronto";
  location.provider = "geoclue2";

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) vim git pciutils usbutils bind nix-prefetch-git brightnessctl;
  };

  services = {
    gnome3.gnome-settings-daemon.enable = true;
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "GoMono Nerd Font" ];
        sansSerif = [ "Roboto" ];
        serif = [ "Liberation Serif" ];
      };
    };
    enableDefaultFonts = true;
    enableFontDir = true;
    fonts = builtins.attrValues {
      inherit (pkgs)
        # icons
        font-awesome_4 nerdfonts
        # proportional
        roboto
        google-fonts
        # monospace
        dina-font fira-code-symbols
        iosevka ibm-plex go-font fira-code
        emacs-all-the-icons-fonts
        ;
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

  programs = {
    sway.enable = true;
    sway.extraPackages = builtins.attrValues {
      inherit (pkgs)
        glib
        xwayland swaybg swayidle swaylock
        mako
        grim slurp
        wl-clipboard
        light
        gtk2fontsel
        libnotify
        inotify-tools # for waybar

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
      inherit (pkgs.xfce) thunar thunar-archive-plugin tumbler;
      inherit (pkgs) redshift-wayland waybar;
      inherit (pkgs.gnome2) gnome_icon_theme;
      inherit (pkgs.gnome3) adwaita-icon-theme;
      python3 = pkgs.python3.withPackages (
        pkgs: [
          pkgs.youtube-dl
        ]
      );
      # spotify
      inherit (pkgs) spotifyd spotify-tui;
    };
    sway.extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
    '';

    gnome-disks.enable = true;

    fish.enable = true;
    zsh.enable = true;
  };
}
