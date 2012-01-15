#!/bin/sh 
##############################################################################
# Reinstate all the dotfiles into their functional locations.
#
# NOTE: make sure and the DOTS variable is correct.
##############################################################################
DOTS="$HOME/dots"

ln -s "$DOTS/bashrc" "$HOME/.bashrc"
ln -s "$DOTS/bin" "$HOME/bin"
ln -s "$DOTS/dircolors" "$HOME/.dircolors"
ln -s "$DOTS/fonts.conf" "$HOME/.fonts.conf"
ln -s "$DOTS/htoprc" "$HOME/.htoprc"
ln -s "$DOTS/irssi" "$HOME/.irssi"
ln -s "$DOTS/mpd" "$HOME/.config/mpd"
ln -s "$DOTS/mplayer" "$HOME/.mplayer"
ln -s "$DOTS/ncmpcpp" "$HOME/.ncmpcpp"
ln -s "$DOTS/pentadactyl" "$HOME/.pentadactyl"
ln -s "$DOTS/pentadactylrc" "$HOME/.pentadactylrc"
ln -s "$DOTS/screenrc" "$HOME/.screenrc"
ln -s "$DOTS/vim" "$HOME/.vim"
ln -s "$DOTS/vimrc" "$HOME/.vimrc"
ln -s "$DOTS/Xdefaults" "$HOME/.Xdefaults"
ln -s "$DOTS/xinitrc" "$HOME/.xinitrc"
#ln -s "$DOTS/xmonad/bitmaps" "$HOME/.xmonad/bitmaps"
#ln -s "$DOTS/xmonadrc" "$HOME/.xmonad/xmonad.hs"
ln -s "$DOTS/zshrc" "$HOME/.zshrc"
ln -s "$DOTS/uzbl/local" "$HOME/.local/share/uzbl"
ln -s "$DOTS/uzbl/config" "$HOME/.config/uzbl"
ln -s "$DOTS/fonts" "/home/meatcar/dots/.fonts"
