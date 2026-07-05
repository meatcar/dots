{
  config,
  pkgs,
  ...
}:
let
  sesh = "${config.programs.sesh.package}/bin/sesh";
  tv = "${config.programs.television.package}/bin/tv";
  tmux = "${pkgs.tmux}/bin/tmux";
  fd = "${pkgs.fd}/bin/fd";
  jj = "${pkgs.jujutsu}/bin/jj";
  git = "${pkgs.git}/bin/git";
in
{
  programs.sesh = {
    enable = true;
    # tmux keys are wired via the `sesh` key-table (tmux.conf) + whichkey.yaml,
    # both calling sesh_tmux; skip the module's raw bind and shell alias.
    enableTmuxIntegration = false;
    enableAlias = false;
    settings = {
      # Hide the opensessions scratch session, mirroring _os_stash filtering.
      blacklist = [ "_os_stash" ];
      # Auto-lay-out sessions under /git (~/git is a symlink to /git). Only
      # fires when sesh *creates* the session (picker); autotmux-created
      # sessions bypass this. Preview lives on the channel below because
      # `sesh preview` does not consult wildcard preview_command.
      wildcard = [
        {
          pattern = "/git/**";
          startup_command = "sesh_startup";
        }
      ];
    };
  };

  # `tv sesh` channel: smart session list, VCS-aware preview. The picker
  # bindings reuse it and override the source per-invocation with -s.
  programs.television.channels.sesh = {
    metadata = {
      name = "sesh";
      description = "sesh smart sessions (tmux + zoxide + config)";
    };
    source.command = "${sesh} list";
    preview.command = "sesh_preview '{}'";
  };

  home.packages = [
    # Dispatcher for the `prefix s` key-table and the which-key submenu.
    # Picker subcommands run television and connect; last/root act directly.
    (pkgs.writeShellScriptBin "sesh_tmux" ''
      set -eu

      pick() {
        # $1: optional source-command override (else the channel default).
        if [ -n "''${1:-}" ]; then
          ${tv} sesh --layout portrait --source-command "$1"
        else
          ${tv} sesh --layout portrait
        fi
      }

      sub=''${1:-pick}

      # Picker subcommands need a TTY: relaunch once inside a tmux popup. This
      # keeps every key binding a bare `run-shell "sesh_tmux X"` (no quoting),
      # which tmux-which-key requires (it wraps menu values in single quotes).
      case "$sub" in
        pick | tmux | zoxide | config | find | kill)
          if [ "''${2:-}" != "__in" ]; then
            exec ${tmux} display-popup -E -y0 "sesh_tmux $sub __in"
          fi
          ;;
      esac

      case "$sub" in
        pick)   sel=$(pick "")                || exit 0 ;;
        tmux)   sel=$(pick "${sesh} list -t") || exit 0 ;;
        zoxide) sel=$(pick "${sesh} list -z") || exit 0 ;;
        config) sel=$(pick "${sesh} list -c") || exit 0 ;;
        find)   sel=$(pick "${fd} -H -d 2 -t d -E .Trash . $HOME") || exit 0 ;;
        kill)
          sel=$(pick "${sesh} list -t") || exit 0
          [ -n "$sel" ] || exit 0
          exec ${tmux} kill-session -t "$sel"
          ;;
        last) exec ${sesh} last ;;
        root) exec ${sesh} connect --root "$(${tmux} display-message -p '#{pane_current_path}')" ;;
        *)
          echo "usage: sesh_tmux {pick|tmux|zoxide|config|find|kill|last|root}" >&2
          exit 2
          ;;
      esac

      [ -n "''${sel:-}" ] || exit 0
      exec ${sesh} connect "$sel"
    '')

    # Channel preview: jj log for a jj repo, git status for a git repo,
    # else sesh's own preview (tmux-session pane content / dir listing).
    (pkgs.writeShellScriptBin "sesh_preview" ''
      set -eu
      entry=''${1:-}
      case "$entry" in
        "~"/*) path="$HOME/''${entry#"~"/}" ;;
        *)     path="$entry" ;;
      esac
      if [ -d "$path" ] && cd "$path" 2>/dev/null; then
        if ${jj} root >/dev/null 2>&1; then
          exec ${jj} log --color always
        elif ${git} rev-parse --git-dir >/dev/null 2>&1; then
          exec ${git} -c color.ui=always s
        fi
      fi
      exec ${sesh} preview "$entry"
    '')

    # /git wildcard startup: claude alongside a jj (or git) TUI.
    (pkgs.writeShellScriptBin "sesh_startup" ''
      if ${jj} root >/dev/null 2>&1; then
        vcs=jjui
      else
        vcs=lazygit
      fi
      ${tmux} split-window -h -d -l 40% -c "$PWD" "$vcs"
      exec claude
    '')
  ];
}
