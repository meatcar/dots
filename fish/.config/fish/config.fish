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

set PATH $PATH $HOME/.emacs.d/bin # DOOM Emacs

source ~/.asdf/asdf.fish
