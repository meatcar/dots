
# Check for an interactive session
[ -z "$PS1" ] && return

txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
txtrst='\e[0m'    # Text Reset

PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

## Aliases

# modified commands
alias ls='ls -FG'
alias mkdir='mkdir -p -v'
alias more='less'
alias svim='sudo vim'
alias sudo='sudo -E'
alias cdfwifi='ssh g0pavlov-cdf@wifi.cs.toronto.edu'

# cd
alias home='cd ~'
alias back='cd $OLDPWD'
alias cd..='cd ..'
alias ..='cd ..'

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

## Colorize manpage via less
export LESS_TERMCAP_mb=$(printf "\e[1;37m")
export LESS_TERMCAP_md=$(printf "\e[1;37m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;47;30m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[0;36m")

## core-git
export PATH="$HOME/Library/Haskell/bin:$PATH"
export EDITOR=vim

## Faster Completion
set show-all-if-ambiguous on
complete -cf sudo
complete -cf man 

paste() {
   URI=$(curl -s -F "sprunge=<-" http://sprunge.us)
   # if stdout is not a tty, suppress trailing newline
   if [[ ! -t 1 ]] ; then local FLAGS='-n' ; fi
   echo $FLAGS $URI
}

