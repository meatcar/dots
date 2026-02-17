{
  nixpkgs-unstable,
  ...
}:
let
  inherit (nixpkgs-unstable) pocket-tts;
in
{
  home.packages = [ pocket-tts ];

  systemd.user.services.pocket-tts = {
    Unit = {
      Description = "Pocket TTS server";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pocket-tts}/bin/pocket-tts serve";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
