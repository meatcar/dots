{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    steamcmd
    steam-tui
    mangohud
    gamescope-wsi
    pkgsi686Linux.gperftools
    protonup-ng
    protonup-qt
  ];

  programs.steam = {
    enable = true;
    package = (pkgs.steam.override { extraLibraries = pkgs: [ pkgs.gperftools ]; });
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;

    protontricks = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.protontricks;
    };
    extraPackages = with pkgs; [
      gamescope
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
    ];
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

    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
