{ config, pkgs, ... }:
let
  inherit (pkgs) tmuxPlugins;
in
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    aggressiveResize = true;
    baseIndex = 1;
    secureSocket = false;
    escapeTime = 0;
    keyMode = "vi";
    shortcut = "a";
    terminal = "tmux-256color";
    plugins = [
      tmuxPlugins.yank
      tmuxPlugins.pain-control
      tmuxPlugins.ctrlw
      {
        plugin = tmuxPlugins.prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_show_copy_mode "on"
        '';
      }
    ];
  };

  home.packages =
    let
      tmux = "${pkgs.tmux}/bin/tmux";
      fzf = "${pkgs.fzf}/bin/fzf";
    in
    [
      (pkgs.writeScriptBin "tmux_session_fzf" ''
        #!/bin/sh
        prompt=$1
        fmt='#{session_id}:|#{?#{session_grouped},@#{session_group},###{session_name}}'
        # fmt='#{session_id}:|#S|(#{session_attached} attached)'
        { ${tmux} display-message -p -F "$fmt" && ${tmux} list-sessions -F "$fmt"; } \
            | awk -F '|' '!seen[$2]++' \
            | column -t -s'|' \
            | ${fzf} --reverse --prompt "$prompt> " \
            | cut -d':' -f1
      '')
      (pkgs.writeScriptBin "tmux_select_session" ''
        #!/bin/sh
        # Select selected tmux session
        # Note: To be bound to a tmux key in from .tmux.conf
        # Example: bind-key s run "tmux new-window -n 'Switch Session' 'bash -ci tmux_select_session'"
        tmux_session_fzf 'switch session' | xargs ${tmux} switch-client -t
      ''
      )
      (pkgs.writeScriptBin "tmux_kill_session" ''
        #!/bin/sh
        tmux_session_fzf 'kill session' \
          | {
            read -r id
            echo "$id"
            next=$(${tmux} list-sessions -F '#{session_id}' | grep -v -F "$id" | head -n1)
            if [ -n "$next" ]; then
              ${tmux} switch-client -t "$next"
            fi && ${tmux} kill-session -t "$id"
          }
      ''
      )
    ];
}
