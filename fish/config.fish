# vim: set ft=fish

eval sh ~/dots/colors/colors.sh
eval sh $COLORSCHEME_DIR/shell/$COLORSCHEME.sh

set PATH $JAVA_HOME "/usr/lib/surfraw" "/usr/lib/ccache/bin/" $PATH 
set PATH $PATH "/home/meatcar/bin" 
set PATH $PATH "/opt/maven/bin"
# npm
set PATH "$HOME/.npm/bin" $PATH 

set VTERM "urxvtc"
set EDITOR "vim"

set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
set JAVA_FONTS /usr/share/fonts/TTF
set MAVEN_OPTS "-Xmx2g -XX:MaxPermSize=256m"

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

