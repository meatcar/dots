# Profile zsh once in a while
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof # Output load-time statistics
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'%D{%M%S%.} %N:%i> '
  export ZSH_STARTUP_LOG="${XDG_CACHE_HOME:-$HOME/tmp}/zsh_startup.$$"
  exec 3>&2 2>"$ZSH_STARTUP_LOG" >/dev/null
  setopt xtrace prompt_subst
  source ~/.login # re-source .login just to make sure
fi


############

HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory hist_ignore_all_dups autocd extendedglob nomatch notify
unsetopt beep

zstyle :compinstall filename "$HOME/.zshrc"

# speed up by not regenerating zcompdump,
# source: https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump.$USER(#qN.mh+24) ]]; then
  compinit -d "${ZDOTDIR:-$HOME}/.zcompdump.$USER"
else
  compinit -d "${ZDOTDIR:-$HOME}/.zcompdump.$USER" -C
fi

### zgen

if [[ ! -d ~/.zgen ]]; then
  git clone https://github.com/tarjoilija/zgen ~/.zgen
fi

source ~/.zgen/zgen.zsh

export NVM_DIR=~/.nvm
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

PURE_PROMPT_SYMBOL=''

ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

ZGEN_AUTOLOAD_COMPINIT=false # we do a better job later.
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)
if ! zgen saved; then

  zgen load 't413/zsh-background-notify'

  zgen load 'lukechilds/zsh-nvm'

  zgen load 'mafredri/zsh-async'
  zgen load 'sindresorhus/pure' pure.zsh

  zgen load "zsh-users/zsh-completions"
  zgen load "greymd/docker-zsh-completion"
  zgen load "zdharma/fast-syntax-highlighting"

  zgen load "zsh-users/zsh-autosuggestions"

  zgen load "lukechilds/zsh-better-npm-completion"

  zgen load 'supercrabtree/k'   # better ls

  zgen save
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zshcache
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' completer _complete _match
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' squeeze-slashes true

# Completion Groups
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'\n%B%d%b\n'

setopt completealiases
#setopt correctall

# Enable wal color theme
if which wal 2>&1 >/dev/null; then
  (cat ~/.cache/wal/sequences &) # silent
fi

if [ $TERMINIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

#zle -N zle-keymap-select

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

zmodload zsh/terminfo
typeset -gA key
key=(
  'Backspace'    "$terminfo[kbs]"
  'Delete'       "$terminfo[kdch1]"
  'Insert'       "$terminfo[kich1]"
  'Home'         "$terminfo[khome]"
  'PageUp'       "$terminfo[kpp]"
  'End'          "$terminfo[kend]"
  'PageDown'     "$terminfo[knp]"
  'Up'           "$terminfo[kcuu1]"
  'Left'         "$terminfo[kcub1]"
  'Down'         "$terminfo[kcud1]"
  'Right'        "$terminfo[kcuf1]"
)

[[ -n "$key[Home]"      ]] && bindkey -- "$key[Home]"      beginning-of-line
[[ -n "$key[End]"       ]] && bindkey -- "$key[End]"       end-of-line
[[ -n "$key[Insert]"    ]] && bindkey -- "$key[Insert]"    overwrite-mode
[[ -n "$key[Backspace]" ]] && bindkey -- "$key[Backspace]" backward-delete-char
[[ -n "$key[Delete]"    ]] && bindkey -- "$key[Delete]"    delete-char
[[ -n "$key[Up]"        ]] && bindkey -- "$key[Up]"        up-line-or-history
[[ -n "$key[Down]"      ]] && bindkey -- "$key[Down]"      down-line-or-history
[[ -n "$key[Left]"      ]] && bindkey -- "$key[Left]"      backward-char
[[ -n "$key[Right]"     ]] && bindkey -- "$key[Right]"     forward-char

if (echo "$TERM" | grep -q "rxvt") && (grep -qEi 'urxvt.keysym.(Home|End)' ~/.Xdefaults); then
  bindkey -- "\e[1~" beginning-of-line
  bindkey -- "\e[4~" end-of-line
fi


bindkey '^R' history-incremental-search-backward
bindkey '^[[c' forward-word # shift+left (accept suggestion)
bindkey '^[OC' forward-word # left (accept partial suggestion)

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init () { echoti smkx }
  function zle-line-finish () { echoti rmkx }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

####################################################
# Set up colorings
#
# ls
eval $(dircolors -b ~/.dircolors)
# grep
export GREP_COLOR="1;33"

# less colors & man
# TODO: remove. Fixed man bug
export MAN_DISABLE_SECCOMP=1
export MANPAGER='less -s -M +Gg'
export LESS="--RAW-CONTROL-CHARS"
lesscolors=$HOME/.less_termcap
[[ -f $lesscolors ]] && . $lesscolors


####################################################
# Aliases
#
alias ls="ls --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias pacman="sudo pacman"
alias mkdir="mkdir -p -v"
alias svim="sudo vim"
alias sudo="sudo -E"
alias tree="tree -AF"
alias mtr="mtr --displaymode 2"

alias t="todo.sh"

# cd
alias cd..="cd .."
alias ..="cd .."

# safety features
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# reconnect sshfs on discnnect.
alias sshfs="sshfs -o reconnect -o compression=yes"
alias proxyhome="ssh -C2TNv -D 8080 home.denys.me"

alias mutt="cd ~/Downloads && neomutt"

# ZSH help
unalias run-help 2>/dev/null
autoload run-help
HELPDIR=/usr/share/zsh/5.4.2/help
alias help=run-help

if which npm 2>&1 >/dev/null; then
  BASEPATH="$PATH"
  function chpwd_npm {
    export PATH="$BASEPATH:$(npm bin)"
  }
  ( chpwd_npm & ) # silent
  chpwd_functions=( ${chpwd_functions} chpwd_npm )

elif which yarn 2>&1 >/dev/null; then

    BASEPATH="$PATH"
    function chpwd_yarn {
        export PATH="$BASEPATH:$(yarn bin)"
    }
    ( chpwd_yarn & ) # silent
    chpwd_functions=( ${chpwd_functions} chpwd_yarn )
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

if [[ "$PROFILE_STARTUP" == true ]]; then
    zprof
    unsetopt xtrace
    exec 2>&3 3>&-
    ~/bin/parse_zsh_profile_log.py "$ZSH_STARTUP_LOG" | awk '{print $2, $0}'  | sort -n

fi

# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
[[ -f /home/meatcar/.local/share/yarn/global/node_modules/tabtab/.completions/yarn.zsh ]] && . /home/meatcar/.local/share/yarn/global/node_modules/tabtab/.completions/yarn.zsh
