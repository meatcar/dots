{
  config,
  pkgs,
  ...
}:
{
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

  xdg.configFile."hrd/config.toml".source = (pkgs.formats.toml { }).generate "hrd-config.toml" {
    roots = {
      github = {
        path = "/git/hub";
        depth = 4;
      };
      gitlab = {
        path = "/git/lab";
        depth = 4;
      };
    };
  };

  home.file.".agents/skills/vcs-repos".source =
    config.lib.file.mkOutOfStoreSymlink "${config.me.PRJ_ROOT}/.agents/skills/vcs-repos";
}
