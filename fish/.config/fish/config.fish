set IS_WSL (uname -a | grep Microsoft)

# Get env from systemd
if [ -z "$IS_WSL" ] && command -qs systemctl 
    systemctl --user show-environment | fishify -x | source -
    systemctl --user import-environment PATH GOPATH
    systemctl --user unset-environment SHLVL PWD # not sure why these get set
end

if not functions -q fisher # Install fisher if not installed
    set -q XDG_CONFIG_HOME || set -x XDG_CONFIG_HOME "$HOME/.config"
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if [ -n "$IS_WSL" ] # Running in WSL
    umask 002 # Fix new file/dir permissions

    # enable x11 apps
    set DISPLAY ':0'
    export DISPLAY
end

# Customize prompt
set pure_symbol_prompt '$'
set pure_symbol_reverse_prompt ':'
set pure_color_success (set_color green)
set pure_color_prompt_on_success (set_color green)

set fish_greeting # Disable fish greeting
fish_vi_key_bindings >/dev/null 2>&1 # pipe error away, fish struggles when Emacs sets TERM=dumb

if [ -d ~/.asdf ]
    source ~/.asdf/asdf.fish
end

if [ -z "$IS_WSL" ] && command -qs systemctl 
    systemctl --user import-environment PATH GOPATH
    systemctl --user unset-environment SHLVL PWD # not sure why these get set
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

if [ -z $SSH_AUTH_SOCK ] && [ -z "$IS_WSL" ]
    /usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh | fishify -x | source - 
    systemctl --user import-environment SSH_AUTH_SOCK
end
