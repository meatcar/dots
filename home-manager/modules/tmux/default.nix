{
  pkgs,
  ...
}:
let
  inherit (pkgs) tmuxPlugins;
  aw-watcher-tmux = tmuxPlugins.mkTmuxPlugin {
    pluginName = "aw-watcher-tmux";
    version = "unstable-2023-10-17";
    src = pkgs.fetchFromGitHub {
      owner = "akohlbecker";
      repo = "aw-watcher-tmux";
      rev = "efaa7610add52bd2b39cd98d0e8e082b1e126487";
      hash = "sha256-L6YLyEOmb+vdz6bJdB0m5gONPpBp2fV3i9PiLSNrZNM=";
    };
    rtpFilePath = "aw-watcher-tmux.tmux";
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram $out/share/tmux-plugins/aw-watcher-tmux/scripts/monitor-session-activity.sh \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.curl
            pkgs.tmux
          ]
        }

      # The upstream loader leaks stdout/stderr from the polling loop into
      # tmux's run-shell capture, which corrupts the status bar.
      cat > $out/share/tmux-plugins/aw-watcher-tmux/aw-watcher-tmux.tmux <<'EOF'
      #!${pkgs.runtimeShell}
      CURRENT_DIR="$( cd "$( dirname "''${BASH_SOURCE[0]}" )" && pwd )"
      "$CURRENT_DIR/scripts/monitor-session-activity.sh" >/dev/null 2>&1 &
      disown || true
      EOF
      chmod +x $out/share/tmux-plugins/aw-watcher-tmux/aw-watcher-tmux.tmux
    '';
    meta.description = "ActivityWatch watcher for tmux sessions";
  };
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-a";
    aggressiveResize = true;
    secureSocket = false;
    terminal = "tmux-256color";
    # Use /bin/sh as default-shell so commands passed to split-window (e.g. by
    # opensessions) can use POSIX ${VAR:-default} syntax, which fish rejects.
    # default-command keeps interactive panes running fish.
    shell = "/bin/sh";
    extraConfig = builtins.readFile ./tmux.conf + ''
      set -g default-command ${pkgs.fish}/bin/fish
      # Sessionizer search roots for opensessions' n/c new-session popup.
      set-environment -g SESSIONIZER_DIR "$HOME/git/hub"
      set-environment -g SESSIONIZER_MAXDEPTH 3
    '';
    plugins = [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.pain-control
      {
        plugin = tmuxPlugins.prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_show_copy_mode "on"
        '';
      }
      aw-watcher-tmux
      pkgs.opensessions
    ];
  };

  home.packages =
    let
      tmux = "${pkgs.tmux}/bin/tmux";
      fzf = "${pkgs.fzf}/bin/fzf";
    in
    [
      (pkgs.writeShellScriptBin "tmux_session_fzf" ''
        prompt=$1
        fmt='#{session_id}:|#{?#{session_grouped},@#{session_group},###{session_name}}'
        # fmt='#{session_id}:|#S|(#{session_attached} attached)'
        { ${tmux} display-message -p -F "$fmt" && ${tmux} list-sessions -F "$fmt"; } \
            | awk -F '|' '$2 != "_os_stash" && !seen[$2]++' \
            | column -t -s'|' \
            | ${fzf} --reverse --prompt "$prompt> " \
            | cut -d':' -f1
      '')
      (pkgs.writeShellScriptBin "tmux_select_session" ''
        # Select selected tmux session
        # Note: To be bound to a tmux key in from .tmux.conf
        # Example: bind-key s run "tmux new-window -n 'Switch Session' 'bash -ci tmux_select_session'"
        tmux_session_fzf 'switch session' | xargs ${tmux} switch-client -t
      '')
      (pkgs.writeShellScriptBin "tmux_kill_session" ''
        tmux_session_fzf 'kill session' \
          | {
            read -r id
            echo "$id"
            next=$(${tmux} list-sessions -F '#{session_id}' | grep -v -F "$id" | head -n1)
            if [ -n "$next" ]; then
              ${tmux} switch-client -t "$next"
            fi && ${tmux} kill-session -t "$id"
          }
      '')
    ];
}
