{
  pkgs,
  ...
}:
let
  tmux = "${pkgs.tmux}/bin/tmux";
in
{
  programs.tmux = {
    plugins = [ pkgs.opensessions ];
    extraConfig = ''
      # Sessionizer search roots for opensessions' n/c new-session popup.
      set-environment -g SESSIONIZER_DIR "$HOME/git/hub"
      set-environment -g SESSIONIZER_MAXDEPTH 3
    '';
  };

  home.packages = [
    (pkgs.writeShellScriptBin "tmux_opensessions" ''
      set -eu
      # Ensure bare tmux/curl are on PATH for the sourced opensessions helpers.
      export PATH="${
        pkgs.lib.makeBinPath [
          pkgs.tmux
          pkgs.curl
        ]
      }:$PATH"
      dir=$(${tmux} show-environment -g OPENSESSIONS_DIR 2>/dev/null \
        | sed -n 's/^OPENSESSIONS_DIR=//p')
      if [ -z "$dir" ]; then
        ${tmux} display-message "opensessions: OPENSESSIONS_DIR not set"
        exit 1
      fi
      scripts="$dir/integrations/tmux-plugin/scripts"

      # Run a tmux window action (next-layout or rotate-window) while keeping
      # the opensessions sidebar pane fixed. Mirrors the stash→act→restore
      # envelope from the plugin's even-horizontal.sh.
      sidebar_safe_window_action() {
        action="$1"
        # server-common.sh derives PLUGIN_DIR via SCRIPT_DIR.
        SCRIPT_DIR="$scripts"
        . "$scripts/sidebar-common.sh"
        . "$scripts/even-horizontal-common.sh"
        . "$scripts/server-common.sh"

        win=$(tmux display-message -p '#{window_id}' 2>/dev/null); [ -n "$win" ] || exit 0
        cur=$(tmux display-message -p '#{pane_id}' 2>/dev/null)
        rows=$(tmux list-panes -t "$win" \
          -F '#{pane_id}|#{pane_title}|#{pane_width}|#{pane_left}|#{pane_right}|#{pane_active}' 2>/dev/null)
        [ -n "$rows" ] || exit 0

        sb=$(count_sidebar_panes "$rows" "$SIDEBAR_PANE_TITLE")
        nsb=$(count_non_sidebar_panes "$rows" "$SIDEBAR_PANE_TITLE")
        # Ambiguous: more than one sidebar pane — do nothing.
        [ "$sb" -gt 1 ] && { tmux switch-client -T root 2>/dev/null || true; exit 0; }
        # Fewer than two non-sidebar panes — nothing meaningful to do.
        [ "$nsb" -lt 2 ] && { tmux switch-client -T root 2>/dev/null || true; exit 0; }

        if [ "$sb" -eq 0 ]; then
          tmux "$action" -t "$win" 2>/dev/null || true
          tmux switch-client -T root 2>/dev/null || true
          exit 0
        fi

        info=$(extract_sidebar_info "$rows" "$SIDEBAR_PANE_TITLE")
        id=$(printf '%s' "$info" | awk -F'|' '{print $1}')
        width=$(printf '%s' "$info" | awk -F'|' '{print $2}')
        left=$(printf '%s' "$info" | awk -F'|' '{print $3}')
        right=$(printf '%s' "$info" | awk -F'|' '{print $4}')
        active=$(printf '%s' "$info" | awk -F'|' '{print $5}')
        side=$(detect_sidebar_side "$rows" "$left" "$right" "$SIDEBAR_PANE_TITLE")
        [ -n "$id" ] && [ -n "$width" ] && [ -n "$side" ] || exit 0

        server_alive && curl -s -o /dev/null -m 0.2 --connect-timeout 0.1 \
          -X POST "http://''${HOST}:''${PORT}/suppress-width-reports?ms=2000" 2>/dev/null || true
        stash_sidebar_pane "$id" || exit 0
        tmux "$action" -t "$win" 2>/dev/null || true
        restore_sidebar_pane "$id" "$win" "$side" "$width" || exit 0
        if [ "$active" = "1" ]; then
          tmux select-pane -t "$id" 2>/dev/null || true
        elif [ -n "$cur" ]; then
          tmux select-pane -t "$cur" 2>/dev/null || true
        fi
        tmux switch-client -T root 2>/dev/null || true
      }

      case "''${1:-}" in
        toggle) exec sh "$scripts/toggle.sh" ;;
        focus)  exec sh "$scripts/focus.sh" ;;
        even)   exec sh "$scripts/even-horizontal.sh" \
                  "$(${tmux} display-message -p '#{window_id}')" \
                  "$(${tmux} display-message -p '#{pane_id}')" ;;
        jump)   exec sh "$scripts/switch-index.sh" "''${2:?index required}" ;;
        layout) sidebar_safe_window_action next-layout ;;
        rotate) sidebar_safe_window_action rotate-window ;;
        *) echo "usage: tmux_opensessions {toggle|focus|even|jump N|layout|rotate}" >&2; exit 2 ;;
      esac
    '')
  ];
}
