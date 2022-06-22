set IS_WSL   (uname -a | grep -i microsoft)

set fish_greeting # Disable fish greeting
# fish struggles when Emacs sets TERM=dumb
fish_vi_key_bindings >/dev/null 2>&1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block

if [ -f ~/.nix-profile/etc/profile.d/nix.sh ] # nix
    fenv source ~/.nix-profile/etc/profile.d/nix.sh
end

if [ -f ~/.nix-defexpr/channels ] \
    && [ "$NIX_PATH[1]" != "$HOME/.nix-defexpr/channels" ]

    set -x NIX_PATH "$HOME/.nix-defexpr/channels:$NIX_PATH"
end

if not functions -q fisher # Install fisher if not installed
    set -q XDG_CONFIG_HOME || set -x XDG_CONFIG_HOME "$HOME/.config"
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if [ -n "$fish_user_paths" ]
    set-fish-user-paths
end

if [ -d ~/.asdf ]
    source ~/.asdf/asdf.fish
end

# color man
set -x LESS_TERMCAP_md (printf "\e[01;31m")
set -x LESS_TERMCAP_me (printf "\e[0m")
set -x LESS_TERMCAP_se (printf "\e[0m")
set -x LESS_TERMCAP_so (printf "\e[01;44;33m")
set -x LESS_TERMCAP_ue (printf "\e[0m")
set -x LESS_TERMCAP_us (printf "\e[01;32m")

set -x MANPAGER "less -R"

# make less behave with XDG
if [ ! -d "$XDG_CACHE_HOME"/less ]
    mkdir -p "$XDG_CACHE_HOME"/less
end
set -x LESSKEY "$XDG_CACHE_HOME"/less/lesskey
set -x LESSHISTFILE "$XDG_CACHE_HOME"/less/history

set -U FZF_LEGACY_KEYBINDINGS 0
fzf_configure_bindings

if [ -z "$SSH_AUTH_SOCK" ] && command -qs gnome-keyring-daemon
    gnome-keyring-daemon --start --components=pkcs11,secrets,ssh | fishify -x | source -
end
