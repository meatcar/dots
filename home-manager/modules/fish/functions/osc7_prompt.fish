function osc7_prompt --on-event fish_prompt
  if grep -q microsoft /proc/version
    printf "\033]7;file://%s\033\\" (wslpath -w "$PWD")
  end
end
