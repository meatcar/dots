let
  goPath = "/git/go";
in
{
  home = {
    sessionPath = [ "${goPath}/bin" ];
    sessionVariables = {
      # need to be in +x dirs
      GOPATH = goPath;
      GOCACHE = "${goPath}/.cache";
    };
  };
  programs.go.telemetry.mode = "off";
}
