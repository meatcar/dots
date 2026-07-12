{
  config,
  lib,
  pkgs,
  ...
}:
{
  # NOTE: Linux only. darwin AMFI kills pnpm's unsigned reflink addon, so forgemap deps fail to build.
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [
      pkgs.forgemap
      pkgs.hrd
    ];

    programs.fish.interactiveShellInit = ''
      ${pkgs.forgemap}/bin/forgemap shell-init fish | source
    '';
    programs.fish.completions.forgemap.body = ''
      ${pkgs.forgemap}/bin/forgemap completion fish | source
    '';

    xdg.configFile."forgemap/forgemap.config.json".source =
      (pkgs.formats.json { }).generate "forgemap.config.json"
        {
          root = "/git";
          defaultForge = "github";
          forges = {
            github = {
              type = "github";
              host = "github.com";
              dir = "hub";
            };
            gitlab = {
              type = "gitlab";
              host = "gitlab.com";
              dir = "lab";
            };
          };
        };

    home.file.".agents/skills/vcs-repos".source =
      config.lib.file.mkOutOfStoreSymlink "${config.me.PRJ_ROOT}/.agents/skills/vcs-repos";
  };
}
