# Ctrl+R history via television, matching fish's native feel:
# --exact    substring matching instead of fuzzy
# --no-sort  keep source order (newest-first) instead of re-ranking by score
# Mirrors tv's own tv_shell_history, which lacks these flags.
function _tv_history_recency
    set -l current_prompt (commandline -cp)

    # move to the next line so the prompt is not overwritten
    printf "\n"

    set -l output (tv fish-history --exact --no-sort --input "$current_prompt" --inline --no-status-bar)

    if test -n "$output"
        commandline -r "$output"
    end

    # move the cursor back to the previous line
    printf "\033[A"
    commandline -f repaint
end
