{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.nautilus
    pkgs.nautilus-python
    pkgs.nautilus-open-any-terminal
  ];
  home.sessionVariables = {
    NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
  };
  dconf.settings."com.github.stunkymonkey.nautilus-open-any-terminal" = {
    terminal = lib.mkIf config.programs.ghostty.enable "ghostty";
  };
}
