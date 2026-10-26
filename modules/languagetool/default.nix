{ lib, pkgs, ... }:
let
  listenPort = 8081;
  backendPort = 8082;
in
{
  services.languagetool = {
    enable = true;
    port = backendPort;
  };

  systemd.sockets.languagetool-proxy = {
    description = "LanguageTool HTTP socket";
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "127.0.0.1:${toString listenPort}" ];
  };

  # NOTE: LanguageTool cannot accept a systemd socket fd; proxy to it instead.
  systemd.services.languagetool-proxy = {
    description = "LanguageTool socket proxy";
    requires = [ "languagetool.service" ];
    after = [ "languagetool.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=1min 127.0.0.1:${toString backendPort}";
      DynamicUser = true;
    };
  };

  systemd.services.languagetool = {
    wantedBy = lib.mkForce [ ];
    unitConfig.StopWhenUnneeded = true;
    # NOTE: JVM exits 143 on SIGTERM
    serviceConfig.SuccessExitStatus = 143;
    # NOTE: JVM takes seconds to bind; hold the proxy until the server answers.
    serviceConfig.ExecStartPost = "${lib.getExe pkgs.curl} -sf -o /dev/null --retry 60 --retry-delay 1 --retry-all-errors http://127.0.0.1:${toString backendPort}/v2/languages";
  };
}
