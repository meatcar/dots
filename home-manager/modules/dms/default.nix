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
  # DMS crash-loops if launched before the Wayland socket exists; wait for it.
  wait-wayland = pkgs.writeShellApplication {
    name = "wait-wayland";
    runtimeInputs = [ pkgs.coreutils ]; # sleep
    text = builtins.readFile ./wait-wayland.sh;
  };
  # The DMS backend binds wlr-gamma-control once, only for outputs present at
  # startup, and never retries. Racing ahead of niri's output enumeration drops
  # the "gamma" capability, breaking night mode until the service restarts. Wait
  # for an enabled output so gamma binds on the first try.
  wait-niri-output = pkgs.writeShellApplication {
    name = "wait-niri-output";
    runtimeInputs = [
      pkgs.niri
      pkgs.coreutils # sleep
      pkgs.gnugrep
    ];
    text = builtins.readFile ./wait-niri-output.sh;
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
  # Teach dms to wait for niri
  systemd.user.services.dms = {
    Unit.After = [ "niri.service" ];
    Unit.BindsTo = [ "niri.service" ];
    Unit.StartLimitIntervalSec = 0;
    Service.ExecStartPre = [
      "${lib.getExe wait-wayland} 30"
      "${lib.getExe wait-niri-output} 30"
    ];
    Service.RestartSec = 1; # restart slower, effectively a poll
  };
  home.packages = with pkgs; [
    kdePackages.kimageformats
    dms-toggle-outputs
    adw-gtk3
  ];
  # Niri's IPC has no output events (26.04), so watch DRM uevents for hotplug.
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
  # systemd-managed so config changes apply on switch without a relogin. The HM
  # module hardcodes a bash-only PATH, so commands need absolute store paths.
  services.swayidle = {
    enable = true; # default extraArgs = [ "-w" ] (wait for command to complete)
    timeouts = [
      {
        timeout = 60 * 15;
        command = "/run/current-system/sw/bin/niri msg action power-off-monitors";
        # no resumeCommand: niri repowers monitors on input automatically
      }
      {
        timeout = 60 * 20;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
    ];
    events = {
      unlock = "${lib.getExe dms-toggle-outputs}";
      after-resume = "${lib.getExe dms-toggle-outputs}";
    };
  };
  # Mirror dms
  systemd.user.services.swayidle.Unit.After = [ "niri.service" ];

  # 1Password registers its tray icon once at startup, but DMS's SNI watcher
  # appears async after the unit is active — wait on the bus name first.
  systemd.user.services."1password" = {
    Unit = {
      After = [ "dms.service" ];
      BindsTo = [ "dms.service" ];
    };
    Service.ExecStartPre = "${pkgs.glib.bin}/bin/gdbus wait --session --timeout 30 org.kde.StatusNotifierWatcher";
  };

  systemd.user.services.darkman = {
    Unit = {
      After = [ "dms.service" ];
      Wants = [ "dms.service" ];
    };
  };
  services.darkman = {
    darkModeScripts = {
      dms = ''
        export ${pathPrefix}
        ${dms} ipc theme dark
      '';
    };
    lightModeScripts = {
      dms = ''
        export ${pathPrefix}
        ${dms} ipc theme light
      '';
    };
  };
}
