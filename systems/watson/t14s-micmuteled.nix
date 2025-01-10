# source: https://github.com/antipatico/nixos-thinkpad-t14-gen5-amd-tweaks/blob/b2aec538015f956fc4417caf8d7197acdf744a53/modules/nixos/services/t14-micmuteled/default.nix
# author: antipatico (https://blog.bootkit.dev)
{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.antipatico; let
  cfg = config.services.t14-micmuteled;
  script = pkgs.writeShellScriptBin "t14-micmuteled-daemon" ''
    #!/usr/bin/env bash

    LED_BRIGHTNESS="$1"
    DEVICE_ID="$2"
    AUDIO_USER_ID="$3"
    SLEEP_INTERVAL="$4"

    OLD=""
    while true; do
      ${pkgs.coreutils}/bin/sleep $SLEEP_INTERVAL
      MIC_STATUS=$(PIPEWIRE_RUNTIME_DIR="/run/user/$AUDIO_USER_ID" ${pkgs.alsa-utils}/bin/amixer cget numid=$DEVICE_ID | ${pkgs.ripgrep}/bin/rg -o 'values=(on|off)+' -r '$1')

      [ "$MIC_STATUS" == "$OLD" ] && continue
      [ "$MIC_STATUS" == 'on' ] && (echo 0 > "$LED_BRIGHTNESS")
      [ "$MIC_STATUS" == 'off' ] && (echo 1 > "$LED_BRIGHTNESS")
      MIC_STATUS=$OLD
    done
  '';
in {
  options.services.t14-micmuteled = with types; {
    enable = mkEnableOption "tweak to make micmute led work on t14 laptop";
    ledBrightness = mkOpt str "/sys/class/leds/platform::micmute/brightness" "Path to the target led to control";
    microphoneNumId = mkOpt int 2 "numid for the microphone to monitor (find out using: amixer controls)";
    userId = mkOpt int 1000 "User id to select the right pipewire socket";
    sleepInterval = mkOpt int 3 "Interval between each check (the higher the less power consumption, the more lag)";
  };

  config = mkIf cfg.enable {
    systemd.services.t14-micmuteled = {
      description = "ThinkPad T14 Mic Mute Led Tweak";
      after = ["network.target"];
      serviceConfig = {
        ExecStart = ''${pkgs.bash}/bin/bash ${script}/bin/t14-micmuteled-daemon "${cfg.ledBrightness}" ${toString cfg.microphoneNumId} ${toString cfg.userId} ${toString cfg.sleepInterval}'';
        Restart = "always";
      };
      wantedBy = ["default.target"];
    };
  };
}
