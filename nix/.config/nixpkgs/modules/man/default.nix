{ config, ... }:
let
  inherit (builtins) getEnv;
  user = getEnv "USER";
in
{
  programs.man.enable = true;
  # Fix mandb as per https://github.com/NixOS/nixpkgs/pull/18521
  home.file.".manpath" = {
    text = ''
      MANPATH_MAP /home/${user}/.nix-profile/bin   /home/${user}/.nix-profile/share/man
      MANPATH_MAP /home/${user}/.nix-profile/sbin  /home/${user}/.nix-profile/share/man
      MANDB_MAP   /home/${user}/.nix-profile/share/man ${config.xdg.cacheHome}/man
    '';
    onChange = "mkdir -p $XDG_CACHE_HOME/man && mandb -u";
  };
}
