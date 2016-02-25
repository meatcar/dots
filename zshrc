####################################################
# Exports

export PATH="$JAVA_HOME:${PATH}:/home/meatcar/bin:/opt/maven/bin"

if which npm 2>&1 >/dev/null; then
  export PATH="$PATH:$HOME/.npm/bin"
  export PATH="$PATH:$(npm bin)"
fi

if which gem 2>&1 >/dev/null; then
  export PATH="$PATH:$HOME/.gem/ruby/2.3.0/bin"
fi

if which ccache 2>&1 >/dev/null; then
  export PATH="/usr/lib/ccache/bin:$PATH"
fi

export TERM="rxvt-256color"
export TERMINAL="urxvtc"
export VTERM="urxvtc"
export EDITOR="vim"
#export PAGER="vimpager"

# fix svn errors
#source /etc/profile.d/go.sh
export GOPATH="$HOME/dev/go"
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2.xrender=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export JAVA_FONTS=/usr/share/fonts/TTF
export MAVEN_OPTS="-Xmx4g -XX:MaxPermSize=256m"

export OG_PPID=$PPID

############

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

zstyle :compinstall filename '/home/meatcar/.zshrc'

autoload -Uz compinit
compinit

source ~/dots/colors/colors.sh
source $COLORSCHEME_DIR/shell/$COLORSCHEME.sh

# Set the prompt.
autoload -U colors && colors

function precmd() {
  eval ${PROMPT_COMMAND}
}

# set up command verb (do, sudo, redo)
root_verb="%(!.%{$fg_bold[red]%}su.)" # elevated privilige
exit_verb="%(?..%{$fg_bold[magenta]%}re)" # failed command
verb="%{$fg_bold[green]%}${exit_verb}${root_verb}do%{$reset_color%}"

IDENTICON=$(identicon -w 6 -h 6)
IDENTICON_TOP="%{[38;5;254m%}$(echo -n ${IDENTICON} | head -n 1)%{$reset_color%}"
IDENTICON_MIDDLE="%{[38;5;254m%}$(echo -n ${IDENTICON} | head -n 2 | tail -n 1)%{$reset_color%}"
IDENTICON_BOTTOM="%{[38;5;254m%}$(echo -n ${IDENTICON} | tail -n 1)%{$reset_color%}"

PUSER="%{$fg_bold[blue]%}%n%{$reset_color%}"
PHOST="%{$fg_bold[magenta]%}%M%{$reset_color%}"
PDIR="%{$fg_bold[green]%}%~%{$reset_color%}"

PROMPT="
${IDENTICON_TOP}
${IDENTICON_MIDDLE} ${PUSER} at ${PHOST} in ${PDIR}
${IDENTICON_BOTTOM}      ${verb} "

####################################################
# Set Keybindings.
bindkey -v
bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

####################################################
# Set up colorings
#
# ls
eval $(dircolors -b ~/.dircolors)
# grep
export GREP_COLOR="1;33"

####################################################
# Aliases
#
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias pacman="sudo pacman"
alias mkdir="mkdir -p -v"
alias svim="sudo vim"
alias sudo="sudo -E"
alias mix="alsamixer"
alias tree="tree -AF"

alias t="todo.sh"

# cd
alias cd..="cd .."
alias ..="cd .."

# safety features
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# reconnect sshfs on discnnect.
alias sshfs="sshfs -o reconnect -C -o workaround=all"
alias proxyhome="ssh -C2TNv -D 8080 home.denys.me"
[[ -s "$HOME/.qfc/bin/qfc.sh" ]] && source "$HOME/.qfc/bin/qfc.sh"
eval "$(thefuck --alias)"

export NVM_DIR="/home/meatcar/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

