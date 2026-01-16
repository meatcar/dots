set -l test_dir (path dirname (status --current-filename))
source "$test_dir/autotmux.fish"

set -g test_root (mktemp -d)
set -g runtime_dir "$test_root/runtime"
set -g project_dir "$test_root/project"
mkdir -p "$runtime_dir" "$project_dir"

set -g tmux_calls "$test_root/tmux_calls"
touch "$tmux_calls"

# Mock tmux with adjustable behavior
set -g tmux_has_session 1
set -g tmux_clients ""
function tmux
    switch "$argv[1]"
        case "has-session"
            return $tmux_has_session
        case "list-clients"
            if test -n "$tmux_clients"
                printf "%s" "$tmux_clients"
            end
            return 0
        case "attach-session" "new-session"
            echo "$argv" >> $tmux_calls
            return 0
        case "*"
            echo "$argv" >> $tmux_calls
            return 0
    end
end

function reset_tmux_calls
    rm -f "$tmux_calls"
    touch "$tmux_calls"
end

set -x XDG_RUNTIME_DIR "$runtime_dir"
set -x DIRENV_DIR "$project_dir"
set -e TMUX

# Test 1: direnv_dir normalization
set -l direnv_dir (__autotmux_direnv_dir)
if test "$direnv_dir" = "$project_dir"
    printf "✓ test 1: direnv_dir normalization\n"
else
    printf "✗ test 1 failed: expected %s got %s\n" "$project_dir" "$direnv_dir" >&2
    exit 1
end

# Test 2: session_name derivation
set -l session_name (__autotmux_session_name)
if test "$session_name" = "project"
    printf "✓ test 2: session_name derivation\n"
else
    printf "✗ test 2 failed: expected 'project' got '%s'\n" "$session_name" >&2
    exit 1
end

# Test 3: autotmux starts a new session when missing
reset_tmux_calls
set -g tmux_has_session 1
set -g tmux_clients ""
set -e TMUX_SESSION_NAME

autotmux
set -l tmux_output (cat "$tmux_calls")
if string match -q "*new-session*" "$tmux_output"
    printf "✓ test 3: tmux starts new session\n"
else
    printf "✗ test 3 failed: tmux new-session not called. Output: '%s'\n" "$tmux_output" >&2
    exit 1
end

# Test 4: autotmux attaches when session exists
reset_tmux_calls
set -g tmux_has_session 0
set -g tmux_clients ""
set -e TMUX_SESSION_NAME

autotmux
set -l tmux_output (cat "$tmux_calls")
if string match -q "*attach-session*" "$tmux_output"
    printf "✓ test 4: tmux attaches to existing session\n"
else
    printf "✗ test 4 failed: tmux attach-session not called. Output: '%s'\n" "$tmux_output" >&2
    exit 1
end

# Test 5: autotmux returns early when already in tmux
reset_tmux_calls
set -x TMUX "attached"
set -e TMUX_SESSION_NAME
set -g tmux_has_session 0
set -g tmux_clients ""

autotmux
set -l tmux_output (cat "$tmux_calls")
if test -z "$tmux_output" && not set -q TMUX_SESSION_NAME
    printf "✓ test 5: autotmux bails when nested\n"
else
    printf "✗ test 5 failed: autotmux should bail when nested. Output: '%s' TMUX_SESSION_NAME: '%s'\n" "$tmux_output" "$TMUX_SESSION_NAME" >&2
    exit 1
end
set -e TMUX

# Test 6: should_attach false when clients present
set -g tmux_has_session 0
set -g tmux_clients "client-1"
__autotmux_should_attach
if test $status -eq 1
    printf "✓ test 6: should_attach blocks with clients\n"
else
    printf "✗ test 6 failed: should_attach should block when clients exist\n" >&2
    exit 1
end

# Test 7: should_attach true when no session
set -g tmux_has_session 1
set -g tmux_clients ""
__autotmux_should_attach
if test $status -eq 0
    printf "✓ test 7: should_attach allows missing session\n"
else
    printf "✗ test 7 failed: should_attach should allow missing session\n" >&2
    exit 1
end

# Test 8: prompt hook fires only once
set -e __autotmux_prompt_fired
set -e TMUX_SESSION_NAME
set -g tmux_has_session 1
set -g tmux_clients ""
reset_tmux_calls

__autotmux_on_prompt
set -l first_session_name "$TMUX_SESSION_NAME"
set -e TMUX_SESSION_NAME
__autotmux_on_prompt
set -l second_session_name "$TMUX_SESSION_NAME"

if test "$first_session_name" = "project" && test -z "$second_session_name"
    printf "✓ test 8: prompt hook fires only once\n"
else
    printf "✗ test 8 failed: prompt hook should fire once only (first: '%s', second: '%s')\n" "$first_session_name" "$second_session_name" >&2
    exit 1
end

# Cleanup
functions -e tmux
rm -rf "$test_root"

printf "ok\n"
