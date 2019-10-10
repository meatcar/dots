# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "release-19.09";
  };
  waylandOverlay = builtins.fetchGit {
    url = "https://github.com/colemickens/nixpkgs-wayland.git";
    ref = "master";
  };
  waylandPkgs = (import waylandOverlay) pkgs pkgs;
in
{
  system.stateVersion = "19.09";

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };

  };

  imports =
    [
      "${home-manager}/nixos"
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "resume" "resume_offset=267520" ];
    resumeDevice = "/dev/mapper/cryptroot";
    blacklistedKernelModules = [ "nouveau" "nvidia" ];
    kernelModules = [ "coretemp" ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
        consoleMode = "auto";
      };
    };
  };

  hardware = {
    bluetooth.enable = true;
    brightnessctl.enable = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      extraPackages = builtins.attrValues {
        inherit (pkgs) vaapiIntel vaapiVdpau libvdpau-va-gl intel-media-driver;
      };
    };
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };
  };

  networking = {
    hostName = "tormund.denys.me";
    wireless.iwd.enable = true;
  };

  time.timeZone = "Asia/Singapore";
  location.provider = "geoclue2";

  environment.systemPackages = [ pkgs.vim pkgs.git ];

  services = {
    fwupd.enable = true;
    acpid.enable = true;
    fstrim.enable = true;
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
    logind.lidSwitch = "hybrid-sleep";
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
        USB_BLACKLIST_PHONE=1
        DISK_DEVICES="nvme0n1"
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
        ENERGY_PERF_POLICY_ON_BAT=power
      '';
    };
  };

  powerManagement = {
    enable = true;
  };

  fonts = {
    fontconfig.enable = true;
    fontconfig.penultimate.enable = true;
    enableDefaultFonts = true;
    enableFontDir = true;
    fonts = [ pkgs.font-awesome pkgs.dina-font pkgs.iosevka ];
  };
  gtk.iconCache.enable = true;

  virtualisation.docker = {
    enable = true;
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
    portal.gtkUsePortal = true;
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
        xdg_utils
        imv
        pcmanfm
        fuse_exfat
        ;
      inherit (waylandPkgs) redshift-wayland wldash;
      inherit (pkgs.gnome3) nautilus;
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
    extraGroups = [ "wheel" "video" "docker" ];
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
      udiskie.enable = true;
    };

    gtk = {
      enable = true;
      iconTheme.package = pkgs.papirus-icon-theme;
      iconTheme.name = "Papirus";
      theme.package = pkgs.plata-theme;
      theme.name = "Plata-Noir-Compact";
      gtk2.extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
      };
    };

    imports = [
      ./home-manager/home.nix
      ./home-manager/pkgs/alacritty
      ./home-manager/pkgs/firefox
    ];
  };
}
