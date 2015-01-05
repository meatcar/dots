#!/bin/sh 
##############################################################################
# Reinstate all the dotfiles into their functional locations.
#
# NOTE: make sure and the DOTS variable is correct.
##############################################################################
DOTS="$PWD"

ln -rs "bashrc" ~/".bashrc"
ln -rs "bin" ~/"bin"
ln -rs "dircolors" ~/".dircolors"
ln -rs "htoprc" ~/".htoprc"
ln -rs "mpd" ~/".config/mpd"
ln -rs "mplayer" ~/".mplayer"
ln -rs "ncmpcpp" ~/".ncmpcpp"
ln -rs "pentadactyl" ~/".pentadactyl"
ln -rs "pentadactylrc" ~/".pentadactylrc"
ln -rs "screenrc" ~/".screenrc"
ln -rs "vim" ~/".vim"
ln -rs "vimrc" ~/".vimrc"
ln -rs "Xdefaults" ~/".Xdefaults"
ln -rs "xinitrc" ~/".xinitrc"
ln -rs "zshrc" ~/".zshrc"
ln -rs "uzbl/local" ~/".local/share/uzbl"
ln -rs "uzbl/config" ~/".config/uzbl"
ln -rs "fonts" ~/".fonts"
ln -rs "irssi" ~/".irssi"
ln -rs "ackrc" ~/".ackrc"
ln -rs "gitconfig" ~/".gitconfig"
ln -rs "i3" ~/".i3"

# TODO: link slim themes + rc

for i in arch_packages; do
   sudo pacman -Syy
   echo "$i" | awk '{ print $1 }' | sudo xargs pacman -S
done
