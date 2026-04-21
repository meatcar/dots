{
  config,
  pkgs,
  ...
}:
let
  restic-backrest = pkgs.writeShellApplication {
    name = "restic-backrest";
    runtimeInputs = with pkgs; [
      jq
      restic
    ];
    text = builtins.readFile ./restic-backrest.sh;
  };
in
{
  environment.systemPackages = with pkgs; [
    restic
    rclone
    backrest
    restic-backrest
    (writeShellApplication {
      name = "restic-timemachine";
      runtimeInputs = [
        jq
        delta
        coreutils
        restic-backrest
      ];
      text = builtins.readFile ./restic-timemachine.sh;
    })
  ];

  systemd.services.backrest = {
    description = "Backrest service";
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [
      pkgs.backrest
      pkgs.rclone
    ];
    environment = {
      BACKREST_PORT = "127.0.0.1:9898";
      BACKREST_DATA = "/var/lib/backrest";
      BACKREST_CONFIG = "/var/lib/backrest/config.json";
      TZ = config.time.timeZone;
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.backrest}/bin/backrest";
      User = "root";
      Group = "root";
      Nice = 10;
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 7;
      StateDirectory = "backrest";
      StateDirectoryMode = "0700";
      PrivateTmp = true;
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
