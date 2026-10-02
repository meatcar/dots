{ config, lib, ... }:
let
  cfg = config.services.hister;
in
lib.mkIf cfg.enable {
  environment.persistence."/persist".directories = [
    {
      directory = if cfg.dataDir != null then cfg.dataDir else "/var/lib/hister";
      inherit (cfg) user group;
      mode = "0750";
    }
  ];
}
