{
  config,
  pkgs,
  lib,
  ...
}:
let
  extraLibraries =
    p: with p; [
      # X11 libraries
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver

      # System libraries
      stdenv.cc.cc.lib
      gamemode
      gperftools
      keyutils
      libkrb5
      libpng
      libpulseaudio
      libvorbis
      mangohud
      lsof

      gperftools
      brotli.lib
      zstd
      openssl
      zlib
      libssh2
      libnghttp2
      libidn2
      glibc
      gtk3

      # for steam-run
      ncurses

      # for nix-ld
      libGLU
      xorg.libX11
      nspr
    ];
  extraPkgs =
    p:
    with p;
    [
      gamescope
      steamtinkerlaunch
    ]
    ++ (extraLibraries p);
in
{
  environment.systemPackages =
    with pkgs;
    [
      steamcmd
      steam-tui
      mangohud
      gamescope-wsi
      pkgsi686Linux.gperftools
      protonup-ng
      protonup-qt
      steamtinkerlaunch
    ]
    ++ [ config.programs.steam.package.run ];

  programs.steam = {
    enable = true;
    package = pkgs.steam.override { inherit extraLibraries extraPkgs; };
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;

    protontricks = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.protontricks;
    };
    extraPackages = extraPkgs pkgs;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  programs.gamescope = {
    enable = true;
    args = [
      "--adaptive-sync"
      "--mangoapp"
      # "--rt"
      "--steam"
    ];
    capSysNice = true;
  };
  programs.gamemode.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
