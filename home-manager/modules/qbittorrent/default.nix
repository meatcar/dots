{
  pkgs,
  lib,
  config,
  ...
}:
let
  # tunnel addresses; must match the wg conf in the secret
  tunnelAddr = "10.2.0.2";
  tunnelGw = "10.2.0.1";
  dynip = pkgs.writeShellApplication {
    name = "qbittorrent-dynip";
    runtimeInputs = with pkgs; [
      curl
      gnugrep
      coreutils
      iproute2
    ];
    text = builtins.readFile ./dynip.sh;
  };
  portfwd = pkgs.writeShellApplication {
    name = "qbittorrent-portfwd";
    runtimeInputs = with pkgs; [
      libnatpmp # natpmpc
      curl
      gawk
      coreutils
    ];
    text = builtins.readFile ./portfwd.sh;
  };
  launch = pkgs.writeShellApplication {
    name = "qbittorrent-launch";
    runtimeInputs = with pkgs; [
      systemd
      qbittorrent
      coreutils
      gawk
      libnotify
      curl
    ];
    text = builtins.readFile ../unmetered/metered.sh + builtins.readFile ./launch.sh;
  };
in
{
  imports = [ ../unmetered ];

  home.packages = [ pkgs.qbittorrent ];

  # stop on metered connections, resume off them
  me.unmetered.suspend = [ "qbittorrent" ];

  # gui as a service so companions can track its lifetime; started on
  # demand by the desktop entry, not at login
  systemd.user.services.qbittorrent = {
    Unit = {
      Description = "qBittorrent";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service.ExecStart = "${pkgs.qbittorrent}/bin/qbittorrent";
  };

  # runs while qbittorrent runs, so the tunnel is live exactly then
  systemd.user.services.qbittorrent-portfwd = {
    Unit = {
      Description = "NAT-PMP port forwarding for qBittorrent";
      After = [ "qbittorrent.service" ];
      BindsTo = [ "qbittorrent.service" ];
    };
    Service = {
      ExecStart = "${portfwd}/bin/qbittorrent-portfwd";
      Environment = "TUNNEL_GW=${tunnelGw}";
      Restart = "on-failure";
      RestartSec = 30;
    };
    Install.WantedBy = [ "qbittorrent.service" ];
  };

  # keeps the tracker pointed at whatever address the tunnel exits from
  systemd.user.services.qbittorrent-dynip = {
    Unit = {
      Description = "Dynamic IP registration for qBittorrent";
      After = [ "qbittorrent.service" ];
      BindsTo = [ "qbittorrent.service" ];
    };
    Service = {
      ExecStart = "${dynip}/bin/qbittorrent-dynip";
      Environment = "DYNIP_CONF=${config.age.secrets.dynip.path} TUNNEL_ADDR=${tunnelAddr}";
      Restart = "on-failure";
      RestartSec = 30;
    };
    Install.WantedBy = [ "qbittorrent.service" ];
  };

  # shadow the package's desktop entry: launch via the service, keep
  # magnet/.torrent associations
  xdg.desktopEntries."org.qbittorrent.qBittorrent" = {
    name = "qBittorrent";
    genericName = "BitTorrent client";
    comment = "Download and share files over BitTorrent";
    exec = "${lib.getExe launch} %U";
    icon = "qbittorrent";
    categories = [
      "Network"
      "FileTransfer"
      "P2P"
      "Qt"
    ];
    mimeType = [
      "application/x-bittorrent"
      "x-scheme-handler/magnet"
    ];
    terminal = false;
    settings = {
      StartupWMClass = "qbittorrent";
      StartupNotify = "false";
      SingleMainWindow = "true";
    };
  };
}
