############

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory hist_ignore_all_dups autocd extendedglob nomatch notify
unsetopt beep

autoload -Uz compinit
compinit

zstyle :compinstall filename '/home/meatcar/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zshcache
zstyle ':completion:*' completer _complete _match
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' squeeze-slashes true

setopt completealiases
#setopt correctall

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/dots/colors/colors.sh
source $COLORSCHEME_DIR/shell/$COLORSCHEME.sh

# Set the prompt.
autoload -U colors && colors
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%{$fg_bold[green]%}+%{$reset_color%}"
zstyle ':vcs_info:*' unstagedstr "%{$fg_bold[grey]%}…%{$reset_color%}"
zstyle ':vcs_info:git:*' branchformat '%b%f%F{red}:%f%F{yellow}%r%f'
zstyle ':vcs_info:git*' formats " %{$fg_bold[yellow]%}%b%{$reset_color%} %m%c%u"
zstyle ':vcs_info:git*' actionformats " %{$fg_bold[green]%}%b%{$reset_color%} (%a) %m%c%u"
setopt prompt_subst

IDENTICON=$(identicon -w 6 -h 6)
IDENTICON_TOP="%{[38;5;254m%}$(echo -n ${IDENTICON} | head -n 1)%{$reset_color%}"
IDENTICON_MIDDLE="%{[38;5;254m%}$(echo -n ${IDENTICON} | head -n 2 | tail -n 1)%{$reset_color%}"
IDENTICON_BOTTOM="%{[38;5;254m%}$(echo -n ${IDENTICON} | tail -n 1)%{$reset_color%}"

PUSER="%{$fg_bold[blue]%}%n%{$reset_color%}"
PHOST="%{$fg_bold[magenta]%}%M%{$reset_color%}"
PDIR="%{$fg_bold[green]%}%~%{$reset_color%}"

function precmd() {
  vcs_info
  set-prompt
}

function set-prompt () {
  # set up command verb (do, sudo, redo)
  root_verb="%(!.%{$fg_bold[red]%}su.)" # elevated privilige
  exit_verb="%(?..%{$fg_bold[magenta]%}re)" # failed command
  verb="%{$fg_bold[green]%}${exit_verb}${root_verb}do%{$reset_color%}"

  case ${KEYMAP} in
    (vicmd)        VI_MODE="%{$bg[blue]%} N %{$reset_color%}";;
    (main|viins|*) VI_MODE="%{$bg[green]%} I %{$reset_color%}" ;;
  esac

  PROMPT="
  ${IDENTICON_TOP}
  ${IDENTICON_MIDDLE} ${PUSER} at ${PHOST} in ${PDIR}
  ${IDENTICON_BOTTOM}      ${verb} "

  RPROMPT="${vcs_info_msg_0_} $VI_MODE"
}

function zle-line-init zle-keymap-select {
  set-prompt
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

####################################################
# Set Keybindings.
bindkey -v
export KEYTIMEOUT=1 # quicker vi ESC
bindkey -sM vicmd '^[' '^G'
bindkey -rM viins '^X'

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

bindkey '^R' history-incremental-search-backward

# for st, makes the delete key work
#function zle-line-init () { echoti smkx }
#function zle-line-finish () { echoti rmkx }
#zle -N zle-line-init
#zle -N zle-line-finish

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

if which npm 2>&1 >/dev/null; then
  BASEPATH="$PATH"
  function chpwd {
    PATH="$BASEPATH:`npm bin`"
  }
  chpwd
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
