# Heuristic:
# - Allow at most one attached tmux client per project session.
# - Event hooks enforce this by checking tmux client state.
# - Manual `autotmux` always attaches/creates the session.
# - A small race is acceptable for single-user usage.

function __autotmux_direnv_dir --description "Get normalized DIRENV_DIR, stripping leading dashes"
  if test -z "$DIRENV_DIR"
    return 1
  end
  set -l direnv_dir (string replace -r "^-+" "" -- "$DIRENV_DIR")
  if test -z "$direnv_dir"
    return 1
  end
  echo "$direnv_dir"
end

function __autotmux_session_name --description "Derive tmux session name from project directory"
  set -l direnv_dir (__autotmux_direnv_dir)
  test -z "$direnv_dir" && return 1
  basename "/$direnv_dir" | tr . -
end

function autotmux --description "Attach to tmux session for current direnv project"
  if test -z "$TMUX" && command -qs tmux
    set -l session_name (__autotmux_session_name)
    test -z "$session_name" && return

    set -gx TMUX_SESSION_NAME "$session_name"

    if tmux has-session -t "$TMUX_SESSION_NAME" >/dev/null 2>&1
      echo "attaching to session $TMUX_SESSION_NAME" >&2
      tmux attach-session -t "$TMUX_SESSION_NAME"
    else
      echo "starting session $TMUX_SESSION_NAME" >&2
      tmux new-session -t "$TMUX_SESSION_NAME"
    end
  end
end


# below are the two main entrypoints. we want to trigger autotmux_session
# 1. when entering a direnv project (DIRENV_DIR is set)
# 2. when the first prompt is shown (for IDE terminals that may not trigger direnv hooks)
function __autotmux_should_attach --description "Return success if no tmux clients are attached"
  set -l session_name (__autotmux_session_name)
  test -z "$session_name" && return 1

  if not command -qs tmux
    return 1
  end

  if not tmux has-session -t "$session_name" >/dev/null 2>&1
    return 0
  end

  set -l clients (tmux list-clients -t "$session_name" 2>/dev/null)
  if test -z "$clients"
    return 0
  end

  return 1
end

function __autotmux_on_direnv_enter --on-variable=DIRENV_DIR --description "Start tmux session when entering a direnv project"
  if __autotmux_should_attach
    autotmux
  end
end

function __autotmux_on_prompt --on-event fish_prompt --description "Trigger autotmux on first prompt for IDE terminals"
  if set -q __autotmux_prompt_fired
    return
  end
  set -g __autotmux_prompt_fired 1
  if test -n "$DIRENV_DIR"
    __autotmux_on_direnv_enter
  end
end
