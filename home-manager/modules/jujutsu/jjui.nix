{
  pkgs,
  lib,
  nixpkgs-unstable,
  inputs,
  ...
}:
{
  home.packages = [
    (pkgs.writeShellScriptBin "jjui" ''
      # jjui's dep doesn't allow tmux to access background color so lets' just lie to it
      # see https://github.com/muesli/termenv/blob/2eeba510a727c7211d3797e19294bf7d8859f726/termenv_unix.go#L238
      # pending on https://github.com/muesli/termenv/pull/123
      export TERM=$(echo "$TERM" | sed 's/^tmux/xterm/');
      ${lib.getExe nixpkgs-unstable.jjui} "$@"
    '')
  ];
  home.file.".config/jjui/themes".source = "${inputs.tinted-jjui}/themes";
  xdg.configFile."jjui/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    ui.theme = {
      light = "base24-catppuccin-latte";
      dark = "base24-catppuccin-mocha";
    };
    preview = {
      show_at_start = true;
    };
    custom_commands = {
      delta = {
        show = "interactive";
        args = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          ''
            jj show -r $change_id --summary --git --color=always | delta --pager 'less -FRX'
          ''
        ];
      };
    };
  };
}
