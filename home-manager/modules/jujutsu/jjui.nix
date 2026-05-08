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
    preview =
      let
        # jj's global ui.diff-formatter is ":git" (so terminal `jj diff` feeds hunk).
        # jjui scrolls in its own pane — pin delta here so the preview stays pretty.
        deltaOverride = [
          "--config"
          ''ui.diff-formatter="delta"''
        ];
      in
      {
        show_at_start = true;
        revision_command = deltaOverride ++ [
          "show"
          "--color"
          "always"
          "-r"
          "$change_id"
        ];
        file_command = deltaOverride ++ [
          "diff"
          "--color"
          "always"
          "-r"
          "$change_id"
          "$file"
        ];
        evolog_command = deltaOverride ++ [
          "evolog"
          "--color"
          "always"
          "-r"
          "$commit_id"
          "-p"
          "-n"
          "1"
        ];
        oplog_command = deltaOverride ++ [
          "op"
          "show"
          "$operation_id"
          "--color"
          "always"
        ];
      };
    actions = [
      {
        name = "hunk-revision";
        desc = "review changeset in hunk";
        lua = ''
          local change_id = context.change_id()
          if change_id then
            jj_interactive("util", "exec", "--", "bash", "-c",
              'jj show -r "$1" --git --color=always | hunk pager',
              "_", change_id)
          end
        '';
      }
      {
        name = "hunk-file";
        desc = "review file diff in hunk";
        lua = ''
          local change_id = context.change_id()
          local file = context.file()
          if change_id and file then
            jj_interactive("util", "exec", "--", "bash", "-c",
              'jj diff -r "$1" --git --color=always -- "$2" | hunk pager',
              "_", change_id, file)
          end
        '';
      }
    ];
    bindings = [
      {
        action = "hunk-revision";
        key = "d";
        scope = "revisions";
        desc = "diff in hunk";
      }
      {
        action = "hunk-file";
        key = "d";
        scope = "revisions.details";
        desc = "diff in hunk";
      }
    ];
  };
}
