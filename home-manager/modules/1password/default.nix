{
  config,
  lib,
  pkgs,
  ...
}:
let
  python = pkgs.python3.withPackages (ps: [
    ps.dbus-python
    ps.pygobject3
  ]);
  screensaver-proxy = pkgs.runCommand "gnome-screensaver-proxy" { } ''
    mkdir -p $out/bin
    cp ${./screensaver-proxy.py} $out/bin/gnome-screensaver-proxy
    chmod +x $out/bin/gnome-screensaver-proxy
  '';
  op-request = pkgs.writeShellApplication {
    name = "op-request";
    runtimeInputs = with pkgs; [
      coreutils
      dash
      git
      gnugrep
      gnused
      systemd
      util-linux
    ];
    text = builtins.readFile ./op-request.sh;
  };
in
{
  home.packages = [ op-request ];
  programs.git.settings."gpg \"ssh\"" = {
    program = "${lib.getExe' config.programs._1password-gui.package "op-ssh-sign"}";
  };
  systemd.user.services."1password" = {
    Unit = {
      Description = "1Password Tray";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe config.programs._1password-gui.package} --silent --ozone-platform-hint=auto";
      Restart = "always";
      KeyringMode = "inherit";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
  systemd.user.services."gnome-screensaver-proxy" = {
    Unit = {
      Description = "org.gnome.ScreenSaver D-Bus proxy for logind lock signals";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Before = [ "1password.service" ];
    };
    Service = {
      ExecStart = "${python}/bin/python3 ${screensaver-proxy}/bin/gnome-screensaver-proxy";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
