{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    restic
    rclone
    backrest
  ];

  systemd.services.backrest = {
    description = "Backrest service";
    wantedBy = ["multi-user.target"];
    requires = ["network-online.target"];
    script = "backrest";
    path = [pkgs.backrest pkgs.rclone];
    environment = {
      BACKREST_PORT = "127.0.0.1:9898";
      TZ = config.time.timeZone;
    };
    serviceConfig = {
      Type = "simple";
      User = "root";
      Group = "root";
    };
  };
}
