# Get env from systemd
which systemctl 2>/dev/null >/dev/null && systemctl --user show-environment | fishify -x | source -

if not functions -q fisher # Install fisher if not installed
    set -q XDG_CONFIG_HOME || set -x XDG_CONFIG_HOME "$HOME/.config"
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if uname -a | grep -q Microsoft # Running in WSL
    umask 002 # Fix new file/dir permissions

    # enable x11 apps
    set DISPLAY ':0'
    export DISPLAY
end

set fish_greeting # Disable fish greeting
fish_vi_key_bindings

set -ax PATH $HOME/.emacs.d/bin # DOOM Emacs

if [ -d ~/.asdf ]
    source ~/.asdf/asdf.fish
end

if which yarn >/dev/null 2>/dev/null 
    set -ax PATH (yarn global bin)
end

if which npm >/dev/null 2>/dev/null
    set -ax PATH (npm bin -g)
end

# alias ls
alias ls 'ls --group-directories-first --color --classify'

# color man
set -x LESS_TERMCAP_md (printf "\e[01;31m")
set -x LESS_TERMCAP_me (printf "\e[0m")
set -x LESS_TERMCAP_se (printf "\e[0m")
set -x LESS_TERMCAP_so (printf "\e[01;44;33m")
set -x LESS_TERMCAP_ue (printf "\e[0m")
set -x LESS_TERMCAP_us (printf "\e[01;32m")

# make less behave with XDG
[ -d "$XDG_CACHE_HOME"/less ] || mkdir -p "$XDG_CACHE_HOME"/less
set -x LESSKEY "$XDG_CACHE_HOME"/less/lesskey
set -x LESSHISTFILE "$XDG_CACHE_HOME"/less/history



if status is-login && [ -z $DISPLAY ] && [ (tty) = /dev/tty1 ]
    systemctl --user import-environment
end

