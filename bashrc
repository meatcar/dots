
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

source /home/meatcar/.git-completion.bash
 
PS1="\[$txtcyn\]\H\[$txtrst\]:\[$txtpur\]\w\[$txtylw\]$(__git_ps1 " (%s)")"
if [[ $EUID -ne 0 ]]; then
    PS1="\[$PS1\]\[$txtgrn\] \$\[$txtrst\] "
else
   PS1="\[$PS1\]\[$txtred\] #\[$txtrst\] "
fi

## Aliases

# modified commands
alias ls='ls --color=always'
alias pacman='sudo pacman'
alias y='yaourt'
alias ys='yaourt -S'
alias yss='yaourt -Ss'
#alias ping='ping -c 5'
alias mkdir='mkdir -p -v'
alias more='less'
alias svim='sudo vim'
alias sudo='sudo -E'
alias mix='alsamixer'
alias less='vimpager'
alias suspend='sudo pm-suspend && slock'
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
export PATH=/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH:/home/meatcar/.bin/
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

