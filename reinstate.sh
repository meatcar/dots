#!/bin/sh 
##############################################################################
# Reinstate all the dotfiles into their functional locations.
#
# NOTE: Before executing this file, make sure all the nescessary dirs exist,
#       and the /home/meatcar/.dots variable is correct.
##############################################################################
ln -s "/home/meatcar/.dots/bashrc" "$HOME/.bashrc"
ln -s "/home/meatcar/.dots/bin" "$HOME/.bin"
ln -s "/home/meatcar/.dots/dircolors" "$HOME/.dircolors"
ln -s "/home/meatcar/.dots/fonts.conf" "$HOME/.fonts.conf"
ln -s "/home/meatcar/.dots/htoprc" "$HOME/.htoprc"
ln -s "/home/meatcar/.dots/irssi" "$HOME/.irssi"
ln -s "/home/meatcar/.dots/mpd" "$HOME/.config/mpd"
ln -s "/home/meatcar/.dots/mplayer" "$HOME/.mplayer"
ln -s "/home/meatcar/.dots/ncmpcpp" "$HOME/.ncmpcpp"
ln -s "/home/meatcar/.dots/pentadactyl" "$HOME/.pentadactyl"
ln -s "/home/meatcar/.dots/pentadactylrc" "$HOME/.pentadactylrc"
ln -s "/home/meatcar/.dots/screenrc" "$HOME/.screenrc"
ln -s "/home/meatcar/.dots/vim" "$HOME/.vim"
ln -s "/home/meatcar/.dots/vimrc" "$HOME/.vimrc"
ln -s "/home/meatcar/.dots/Xdefaults" "$HOME/.Xdefaults"
ln -s "/home/meatcar/.dots/xinitrc" "$HOME/.xinitrc"
ln -s "/home/meatcar/.dots/xmonad/bitmaps" "$HOME/.xmonad/bitmaps"
ln -s "/home/meatcar/.dots/xmonadrc" "$HOME/.xmonad/xmonad.hs"
ln -s "/home/meatcar/.dots/zshrc" "$HOME/.zshrc"
ln -s "/home/meatcar/.dots/dwm" "/home/meatcar/.dots/.dwm"
