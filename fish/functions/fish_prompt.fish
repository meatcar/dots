set fish_greeting ""

set -g __fish_git_prompt_show_informative_status 1 
set -g __fish_git_prompt_hide_untrackedfiles 1 

set -g __fish_git_prompt_color_branch magenta bold 
set -g __fish_git_prompt_showupstream "informative" 
set -g __fish_git_prompt_char_upstream_ahead "↑" 
set -g __fish_git_prompt_char_upstream_behind "↓" 
set -g __fish_git_prompt_char_upstream_prefix "" 

set -g __fish_git_prompt_char_stagedstate "~" 
set -g __fish_git_prompt_char_dirtystate "✗" 
set -g __fish_git_prompt_char_untrackedfiles "…" 
set -g __fish_git_prompt_char_conflictedstate "!" 
set -g __fish_git_prompt_char_stagedstate "✔" 

set -g __fish_git_prompt_color_dirtystate blue 
set -g __fish_git_prompt_color_stagedstate yellow 
set -g __fish_git_prompt_color_invalidstate red 
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal 
set -g __fish_git_prompt_color_cleanstate green bold

function fish_prompt
   set -l last_status $status

   set IDENTICON (identicon -w 6 -h 6)

   printf '\n%s\n' $IDENTICON[1]
   printf '%s ' $IDENTICON[2]
   set_color --bold blue
   printf '%s' (whoami)
   set_color normal
   printf ' at '

   set_color --bold magenta
   printf '%s' (hostname|cut -d . -f 1)
   set_color normal
   printf ' in '

   set_color --bold $fish_color_cwd
   printf '%s' (prompt_pwd)
   set_color normal

   if not set -q __fish_prompt_normal 
      set -g __fish_prompt_normal (set_color normal) 
   end
   printf ' %s ' (__fish_git_prompt)

   printf '\n'

   printf '%s   ' $IDENTICON[3]

   if [ $last_status -ne 0 ]
      set_color --bold $fish_color_error 
      printf 'redo '
   else
      set_color --bold green
      printf '  do '
   end
   set_color normal
end
