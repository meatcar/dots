# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "release-19.09";
  };
  waylandOverlay = builtins.fetchGit {
    url = "https://github.com/colemickens/nixpkgs-wayland.git";
    ref = "master";
  };
  waylandPkgs = (import waylandOverlay) {} pkgs;
in
{
  system.stateVersion = "19.09";
  nixpkgs = {
    overlays = [ (import waylandOverlay) ];
    config = {
      allowUnfree = true;
      pulseaudio = true;
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
    };
  };
  documentation.dev.enable = true;

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };
  };

  imports = [
    "${home-manager}/nixos"
    ./hardware-configuration.nix
    ./modules/networking.nix
    ./modules/keyring.nix
    # ./modules/ly.nix
  ];

  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelModules = [ "acpi_call" ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [
      config.boot.kernelPackages.acpi_call
      config.boot.kernelPackages.nvidia_x11
    ];
    kernelParams = [
      "resume"
      "resume_offset=267520"
      "mem_sleep_default=deep"
      "nouveau.blacklist=0"
      "acpi_osi=!"
      "acpi_osi=\"Windows 2015\""
      "acpi_backlight=vendor"
      "i915.fastboot=1"
      "i915.enable_fbc=1"
      "i915.enable_psr=1"
      "i915.enable_guc=2"
    ];
    resumeDevice = "/dev/mapper/cryptroot";
    blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "rivafb"
      "nvidiafb"
      "rivatv"
      "nv"
      "nvidia_modeset"
      "nvidia_drm"
    ];
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
    bluetooth.enable = true;
    brightnessctl.enable = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      extraPackages = builtins.attrValues {
        inherit (pkgs) vaapiIntel vaapiVdpau
          libvdpau-va-gl intel-media-driver
          ;
      };
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = null; # managed by tlp
  };

  networking.hostName = "tormund.denys.me";

  time.timeZone = "Asia/Singapore";
  location.provider = "geoclue2";

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) vim git powertop pciutils usbutils bind nix-prefetch-git;
  };

  services = {
    fwupd.enable = true;
    acpid.enable = true;
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
      '';
    };
    upower.enable = true;
    undervolt = {
      enable = true;
      analogioOffset = "0";
      coreOffset = "-110";
      uncoreOffset = "-110";
      gpuOffset = "-70";
    };
    printing.enable = true;
    tlp = {
      enable = true;
      extraConfig = ''
        DEVICES_TO_DISABLE_ON_STARTUP="bluetooth"
        USB_BLACKLIST_PHONE=1
        DISK_DEVICES="nvme0n1"
        TLP_DEFAULT_MODE=BAT
        TLP_PERSISTENT_DEFAULT=1
        CPU_SCALING_GOVERNOR_ON_AC=powersave
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
      '';
    };
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
        # monospace
        dina-font fira-code-symbols
        iosevka ibm-plex go-font fira-code
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
      waylandPkgs.xdg-desktop-portal-wlr
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

        # File Management
        xdg_utils
        udiskie
        fuse_exfat
        exfat-utils
        ntfs3g
        hicolor-icon-theme
        breeze-icons
        imv
        zathura
        mpv
        streamlink
        chromium

        # audio
        pavucontrol
        ncpamixer

        # power
        s-tui
        ;
      inherit (pkgs.xfce) thunar thunar-archive-plugin tumbler;
      inherit (waylandPkgs) redshift-wayland wldash waybar;
      inherit (pkgs.gnome2) gnome_icon_theme;
      inherit (pkgs.gnome3) adwaita-icon-theme;
      python3 = pkgs.python3.withPackages (
        packages: [
          packages.mps-youtube
          packages.youtube-dl
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

  users.mutableUsers = false;
  users.users.meatcar = {
    isNormalUser = true;
    useDefaultShell = false;
    shell = "/run/current-system/sw/bin/fish";
    # nix-shell -p mkpasswd --command 'mkpasswd -m sha-512'
    hashedPassword = "$6$d60LJzot5J$PeWx9sU6rPNEy39uSewpJiV5CfOh9McENT5Crl4WCFyvwL/5jyH7Jn2pENG6pEWPNNFl2Xnp4WGEJEMAU2Mym0";
    extraGroups = [ "wheel" "video" "docker" "networkmanager" ];
  };

  home-manager.users.meatcar = { pkgs, ... }: {
    home.stateVersion = "19.09";

    nixpkgs.config = config.nixpkgs.config // import ./home-manager/config.nix;
    xdg.configFile."nixpkgs/config.nix".source = ./home-manager/config.nix;

    imports = [
      ./home-manager/home.nix
      ./home-manager/modules/gnome-keyring.nix
      ./home-manager/modules/alacritty
      ./home-manager/modules/firefox
    ];

    xdg.configFile = {
      "sway" = {
        source = ./dots/sway/.config/sway;
        onChange = "swaymsg -qt send_tick && swaymsg reload";
      };
      "swaylock".source = ./dots/sway/.config/swaylock;
      "wldash".source = ./dots/sway/.config/wldash;
      "waybar".source = ./dots/waybar/.config/waybar;
      "mako".source = ./dots/mako/.config/mako;
      "redshift".source = ./dots/redshift/.config/redshift;
    };

    services = {
      syncthing.enable = true;
      keybase.enable = true;
      kbfs.enable = true;
    };

    gtk = {
      enable = true;
      iconTheme.package = pkgs.papirus-icon-theme;
      iconTheme.name = "Papirus-Dark";
      theme.package = pkgs.plata-theme;
      theme.name = "Plata-Noir-Compact";
      font.package = pkgs.roboto;
      font.name = "Roboto 9";
    };

    programs.neovim.package = lib.mkForce pkgs.unstable.neovim-unwrapped;
  };
}
