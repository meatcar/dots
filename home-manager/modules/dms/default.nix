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
  dmsPkg = import ./dms-shell.nix { inherit pkgs inputs; };
  dms = lib.getExe dmsPkg;
  dms-toggle-outputs = pkgs.writeShellApplication {
    name = "dms-toggle-outputs";
    runtimeInputs = [ dmsPkg ];
    text = builtins.readFile ./dms-toggle-outputs.sh;
  };
  dms-output-watch = pkgs.writeShellApplication {
    name = "dms-output-watch";
    runtimeInputs = with pkgs; [
      systemd # udevadm
      coreutils # stdbuf, seq, sleep
      gnugrep
      dmsPkg
      dms-toggle-outputs
    ];
    text = builtins.readFile ./dms-output-watch.sh;
  };
  pathPrefix = "PATH=${lib.makeBinPath [ cfg.quickshell.package ]}:$PATH";
in
{
  programs.dank-material-shell = {
    enable = true;
    package = dmsPkg;
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
    dms-toggle-outputs
  ];
  # Apply the matched output profile on display hotplug. Niri's IPC event
  # stream has no output events (as of 26.04), so watch DRM uevents instead.
  systemd.user.services.dms-output-watch = {
    Unit = {
      Description = "Apply matched dms output profile on display hotplug";
      After = [ "dms.service" ];
      PartOf = [ "dms.service" ];
    };
    Service = {
      ExecStart = lib.getExe dms-output-watch;
      Restart = "always";
      RestartSec = 2;
    };
    Install.WantedBy = [ "dms.service" ];
  };
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
