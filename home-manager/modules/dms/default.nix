{
  config,
  pkgs,
  lib,
  inputs,
  nixpkgs-unstable,
  ...
}:
let
  cfg = config.programs.dank-material-shell;
  dms = lib.getExe inputs.dank-material-shell.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell;
  pathPrefix = "PATH=${lib.makeBinPath [ cfg.quickshell.package ]}:$PATH";
in
{
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    quickshell.package = nixpkgs-unstable.quickshell;
    dgop.package = nixpkgs-unstable.dgop;
  };
  # Start DMS after Niri's socket is ready (niri is Type=notify).
  # Note: niri sends READY before flushing wl_output globals, so this ordering
  # is necessary but not fully sufficient — the Qt null-deref patch in recent
  # quickshell builds is the real fix (quickshell issue #677).
  systemd.user.services.dms.Unit.After = [ "niri.service" ];
  home.packages = with pkgs; [
    kdePackages.kimageformats
  ];
  systemd.user.services.darkman = {
    Unit = {
      After = [ "dms.service" ];
      Wants = [ "dms.service" ];
    };
  };
  # Bind 1Password to DMS so it cannot start until DMS is active and stops
  # when DMS stops. dms.service going active is not sufficient — quickshell
  # claims org.kde.StatusNotifierWatcher asynchronously after the service is
  # ready, and 1Password only attempts tray registration once at startup. Block
  # on the bus name with gdbus wait so the SNI watcher is guaranteed present.
  systemd.user.services."1password" = {
    Unit = {
      After = [ "dms.service" ];
      BindsTo = [ "dms.service" ];
    };
    Service.ExecStartPre = "${pkgs.glib.bin}/bin/gdbus wait --session --timeout 30 org.kde.StatusNotifierWatcher";
  };

  services.darkman = {
    darkModeScripts = {
      dms = ''
        export ${pathPrefix}
        ${dms} ipc night enable
        ${dms} ipc theme dark
      '';
    };
    lightModeScripts = {
      dms = ''
        export ${pathPrefix}
        ${dms} ipc night disable
        ${dms} ipc theme light
      '';
    };
  };
}
