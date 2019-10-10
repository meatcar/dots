set IS_WSL   (uname -a | grep -i microsoft)
set IS_NIXOS (uname -a | grep NixOS )

# Get env from systemd
if [ -z "$IS_WSL" ] && [ -z "$IS_NIXOS" ] && command -qs systemctl
    systemctl --user show-environment | fishify -x | source -
    systemctl --user import-environment PATH GOPATH
    systemctl --user unset-environment SHLVL PWD # not sure why these get set
end

if [ -f ~/.nix-profile/etc/profile.d/nix.sh ] # nix
    fenv source ~/.nix-profile/etc/profile.d/nix.sh
end
if [ "$NIX_PATH[1]" != "$HOME/.nix-defexpr/channels" ]
    set -x NIX_PATH "$HOME/.nix-defexpr/channels:$NIX_PATH"
end
if [ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ] # home-manager
    fenv source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
end

if not functions -q fisher # Install fisher if not installed
    set -q XDG_CONFIG_HOME || set -x XDG_CONFIG_HOME "$HOME/.config"
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if [ -n "$fish_user_paths" ]
    set-fish-user-paths
end

if [ -n "$IS_WSL" ] # Running in WSL
    # umask 002 # Fix new file/dir permissions

    # enable x11 apps
    # set -x DISPLAY ':0'
end

set fish_greeting # Disable fish greeting
fish_vi_key_bindings >/dev/null 2>&1 # pipe error away, fish struggles when Emacs sets TERM=dumb

if [ -d ~/.asdf ]
    source ~/.asdf/asdf.fish
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

set -x MANPAGER "less -R"

# make less behave with XDG
[ -d "$XDG_CACHE_HOME"/less ] || mkdir -p "$XDG_CACHE_HOME"/less
set -x LESSKEY "$XDG_CACHE_HOME"/less/lesskey
set -x LESSHISTFILE "$XDG_CACHE_HOME"/less/history

if [ -z $SSH_AUTH_SOCK ] && [ -z "$IS_WSL" ] && command -qs gnome-keyring-daemon
    gnome-keyring-daemon --start --components=pkcs11,secrets,ssh | fishify -x | source -
    systemctl --user import-environment SSH_AUTH_SOCK
end
