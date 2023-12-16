{
  config,
  lib,
  ...
}: {
  programs.keychain = {
    enable = true;
    keys = ["id_ed25519"];
    extraFlags = ["--noask --quiet"];
  };

  #FIXME: https://github.com/nix-community/home-manager/issues/2256
  programs.keychain.enableBashIntegration = false;
  programs.bash.initExtra = with lib; let
    cfg = config.programs.keychain;
    flags =
      cfg.extraFlags
      ++ optional (cfg.agents != [])
      "--agents ${concatStringsSep "," cfg.agents}"
      ++ optional (cfg.inheritType != null) "--inherit ${cfg.inheritType}";
    shellCommand = "${cfg.package}/bin/keychain --eval ${concatStringsSep " " flags} ${concatStringsSep " " cfg.keys}";
  in ''
    eval "$(SHELL=bash ${shellCommand})"
  '';
}
