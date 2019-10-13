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
  nixpkgs.config.allowUnfree = true;

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

  imports =
    [
      "${home-manager}/nixos"
      ./hardware-configuration.nix
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
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
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
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = null; # managed by tlp
  };

  networking = {
    hostName = "tormund.denys.me";
    # wireless.iwd.enable = true;
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Singapore";
  location.provider = "geoclue2";

  environment.systemPackages = [ pkgs.vim pkgs.git pkgs.powertop ];

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
    dnscrypt-proxy.enable = true;
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
    fontconfig.enable = true;
    fontconfig.ultimate.enable = true;
    enableDefaultFonts = true;
    enableFontDir = true;
    fonts = [ pkgs.font-awesome_4 pkgs.dina-font pkgs.iosevka pkgs.nerdfonts ];
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
        waybar
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
        imv
        hicolor-icon-theme
        breeze-icons

        # audio
        pavucontrol
        ncpamixer
        ;
      inherit (pkgs.xfce) thunar thunar-archive-plugin tumbler;
      inherit (waylandPkgs) redshift-wayland wldash;
      inherit (pkgs.gnome2) gnome_icon_theme;
      inherit (pkgs.gnome3) adwaita-icon-theme;
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

  systemd.services = {
    ly = {
      enable = true;
      description = "TUI display manager";
      documentation = [ "https://github.com/cylgom/ly" ];
      after = [ "systemd-user-sessions.service" "plymouth-quit-wait.service" "getty@tty2.service" ];
      aliases = [ "display-manager.service" ];
      serviceConfig = {
        Type = "idle";
        ExecStart = "${pkgs.ly}/bin/ly";
        StandadInput = "tty";
        TTYPath = "/dev/tty2";
        TTYReset = "yes";
        TTYVHangup = "yes";
      };
    };
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

    nixpkgs.config = import ./home-manager/config.nix;
    xdg.configFile."nixpkgs/config.nix".source = ./home-manager/config.nix;

    xdg.configFile = {
      "sway".source = ./dots/sway/.config/sway;
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

    imports = [
      ./home-manager/home.nix
      ./home-manager/pkgs/alacritty
      ./home-manager/pkgs/firefox
    ];
  };
}
