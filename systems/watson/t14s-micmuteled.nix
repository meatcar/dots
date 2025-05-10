{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.t14-micmuteled;
  script = pkgs.writeShellScript "t14-micmuteled-daemon" (builtins.readFile ./t14s-micmuteled.sh);
in
{
  options.services.t14-micmuteled = with lib.types; {
    enable = lib.mkEnableOption "tweak to make micmute led work on t14 laptop";
    ledBrightness = lib.mkOption {
      type = str;
      default = "/sys/class/leds/platform::micmute/brightness";
      description = "Path to the target led to control";
    };
    userId = lib.mkOption {
      type = int;
      default = 1000;
      description = "User id to select the right pipewire socket";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.t14-micmuteled = {
      description = "ThinkPad T14 Mic Mute Led Tweak";
      after = [ "network.target" ];
      path = [
        pkgs.pipewire
        pkgs.jq
      ];
      serviceConfig = {
        ExecStart = ''${pkgs.bash}/bin/bash ${script} "${cfg.ledBrightness}" ${toString cfg.userId}'';
        Restart = "always";
        Type = "simple";
      };
      wantedBy = [ "default.target" ];
    };
  };
}
