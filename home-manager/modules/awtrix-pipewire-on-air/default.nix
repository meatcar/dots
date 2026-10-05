{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  package = inputs.awtrix-pipewire-on-air.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [ package ];

  systemd.user.services.awtrix-pipewire-on-air = {
    Unit = {
      Description = "PipeWire microphone ON AIR indicator";
      After = [ "pipewire.service" ];
      Requires = [ "pipewire.service" ];
    };
    Service = {
      ExecStart = "${package}/bin/awtrix-pipewire-on-air";
      Environment = [
        "PATH=${
          lib.makeBinPath [
            pkgs.pipewire
            pkgs.jq
          ]
        }"
      ];
      Restart = "always";
      RestartSec = 5;
      TimeoutStopSec = 15;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
