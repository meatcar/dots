####################################################
# Exports

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

if [ -d "$HOME/bin" ] ; then
    export PATH="$PATH:$HOME/bin"
fi
export PATH="$JAVA_HOME:${PATH}"
export PATH="${PATH}:$HOME/.local/bin"
export PATH="${PATH}:/opt/maven/bin"

if which npm 2>&1 >/dev/null; then
  export PATH="$PATH:$HOME/.npm/bin"
fi

if which yarn 2>&1 >/dev/null; then
  export PATH="$PATH:$HOME/.yarn/bin"
fi

if which gem 2>&1 >/dev/null; then
  export PATH="$PATH:$HOME/.gem/ruby/2.5.0/bin"
fi

if which ccache 2>&1 >/dev/null; then
  export PATH="/usr/lib/ccache/bin:$PATH"
fi

export GOPATH="$HOME/dev/go"
if which go 2>&1 >/dev/null; then
  export PATH="$PATH:$GOPATH/bin"
fi

#export TERM="xterm-256color"
#export TERMINAL="gnome-terminal"
export TERMINAL="alacritty"
export EDITOR="vim"
#export PAGER="vimpager"

# fix svn errors
#source /etc/profile.d/go.sh

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2.xrender=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export JAVA_FONTS=/usr/share/fonts/TTF
export MAVEN_OPTS="-Xmx4g -XX:MaxPermSize=256m"

export OG_PPID=$PPID

if [ -n "$DESKTOP_SESSION" ] && [ "$UID" -gt 0 ]; then
  eval $(gnome-keyring-daemon --start)
  export SSH_AUTH_SOCK
fi

[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || export QT_QPA_PLATFORMTHEME="qt5ct"

if [ "$UID" -gt 0 ]; then
  systemctl --user import-environment PATH
fi
