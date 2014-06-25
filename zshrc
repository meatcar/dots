# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/meatcar/.zshrc'

source /usr/bin/aws_zsh_completer.sh

autoload -Uz compinit
compinit

#####################################################
# Antigen Bundles
#####################################################
#export ADOTDIR="$HOME/.zsh"
#source $ADOTDIR/antigen.zsh

#antigen bundle zsh-users/zsh-syntax-highlighting
#antigen bundle git
#antigen bundle command-not-found
#antigen bundle kennethreitz/autoenv

#antigen apply

# End of lines added by compinstall
####################################################
# The following lines were added by meatcar
####################################################
# Set the prompt.
autoload -U colors && colors

function precmd() {
  eval ${PROMPT_COMMAND}
}

# set up command verb (do, sudo, redo)
root_verb="%(!.%{$fg_bold[red]%}su.)" # elevated privilige
exit_verb="%(?..%{$fg_bold[magenta]%}re)" # failed command
verb="%{$fg_bold[green]%}${exit_verb}${root_verb}do%{$reset_color%}"


PROMPT="%{$fg_bold[blue]%}%n%{$reset_color%} at %{$fg_bold[magenta]%}%M%{$reset_color%} in %{$fg_bold[green]%}%~%{$reset_color%}
    ${verb} "
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
# Exports
#
export VTERM="urxvtc"
export EDITOR="vim"
#export PAGER="vimpager"
export PATH="/usr/lib/surfraw:/usr/lib/ccache/bin/:${PATH}:/home/meatcar/bin:/home/meatcar/.gem/ruby/1.9.1/bin:/opt/softkinetic/DepthSenseSDK/bin"
export LD_LIBRARY_PATH="/opt/softkinetic/DepthSenseSDK/lib/"
# fix svn errors
#source /etc/profile.d/go.sh
export GOPATH="$HOME/dev/go:$GOPATH"
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
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

# cd 
alias cd..="cd .."
alias ..="cd .."

# safety features
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# reconnect sshfs on discnnect.
alias sshfs="sshfs -o reconnect -C -o workaround=all"

