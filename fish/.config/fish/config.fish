if not functions -q fisher # Install fisher if not installed
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
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

set -a PATH $HOME/.emacs.d/bin # DOOM Emacs

if which yarn >/dev/null 2>/dev/null 
    set -a PATH (yarn global bin)
end

if which npm >/dev/null 2>/dev/null
    set -a PATH (npm bin -g)
end

if [ -d ~/.asdf ]
    source ~/.asdf/asdf.fish
end

# Launch Sway
if [ -z $DISPLAY ] && [ (tty) = /dev/tty1 ]
    systemctl --user import-environment
    exec sway
end
