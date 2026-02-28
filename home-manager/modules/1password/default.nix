{
  lib,
  pkgs,
  nixpkgs-unstable,
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
in
{
  programs.ssh.matchBlocks."*".extraOptions = {
    IdentityAgent = "~/.1password/agent.sock";
  };
  programs.git.settings."gpg \"ssh\"" = {
    program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
  };
  systemd.user.services."1password" = {
    Unit = {
      Description = "1Password Tray";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe nixpkgs-unstable._1password-gui} --silent --ozone-platform-hint=auto";
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
