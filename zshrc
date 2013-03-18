# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/meatcar/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
####################################################
# The following lines were added by meatcar
####################################################
# Set the prompt.
autoload -U colors && colors

# set up command verb (do, sudo, redo)
root_verb="%(!.%{$fg[red]%}su.)" # elevated privilige
exit_verb="%(?..%{$fg[yellow]%}re)" # failed command
verb="%{$fg[green]%}${exit_verb}${root_verb}do%{$reset_color%}"


PROMPT="%{$fg[blue]%}%n%{$reset_color%} at %{$fg[magenta]%}%M%{$reset_color%} in %{$fg[yellow]%}%~%{$reset_color%}
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
export BROWSER="firefox"
#export PAGER="vimpager"
export PATH="/usr/share/perl5/vendor_perl/auto/share/dist/Cope:${PATH}:/home/meatcar/bin:/home/meatcar/.gem/ruby/1.9.1/bin"
# fix svn errors
export LC_CTYPE=C
####################################################
# Set up colorings
#
# ls
eval $(dircolors -b ~/.dircolors)
# grep 
export GREP_COLOR="1;33"
# less syntax-hilite
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '
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
alias suspend="sudo pm-suspend"
alias cdfwifi="ssh g0pavlov-cdf@wifi.cs.toronto.edu"
alias v="mvimc"

# cd 
alias cd..="cd .."
alias ..="cd .."

# safety features
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

## Colorize manpage via less
export LESS_TERMCAP_mb=$(printf "\e[1;37m")
export LESS_TERMCAP_md=$(printf "\e[1;37m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;47;30m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[0;36m")

