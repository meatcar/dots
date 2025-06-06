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

if [ -n "$fish_user_paths" ]
    set-fish-user-paths
end

if [ -d ~/.asdf ]
    source ~/.asdf/asdf.fish
end

# make less behave with XDG
if [ ! -d "$XDG_CACHE_HOME"/less ]
    mkdir -p "$XDG_CACHE_HOME"/less
end
set -x LESSKEY "$XDG_CACHE_HOME"/less/lesskey
set -x LESSHISTFILE "$XDG_CACHE_HOME"/less/history

fzf_configure_bindings

if [ -z "$SSH_AUTH_SOCK" ] && command -qs gnome-keyring-daemon
    gnome-keyring-daemon --start --components=pkcs11,secrets,ssh | fishify -x | source -
end

set -U --append __done_exclude '^tmux'
