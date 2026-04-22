{ config, lib, ... }:
let
  cfg = config.services.netdata;
in
lib.mkIf cfg.enable {
  environment.persistence."/persist".directories = [
    {
      directory = "/var/cache/netdata";
      inherit (cfg) user;
      inherit (cfg) group;
      mode = "0750";
    }
    {
      directory = "/var/lib/netdata";
      inherit (cfg) user;
      inherit (cfg) group;
      mode = "0750";
    }
  ];
}
