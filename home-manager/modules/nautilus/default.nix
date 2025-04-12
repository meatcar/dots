{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.nautilus
    pkgs.nautilus-open-any-terminal
  ];
  dconf.settings."com.github.stunkymonkey.nautilus-open-any-terminal" = {
    terminal = lib.mkIf config.programs.ghostty.enable "ghostty";
  };
}
