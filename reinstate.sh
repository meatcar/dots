#!/bin/sh 
##############################################################################
# Reinstate all the dotfiles into their functional locations.
#
# NOTE: Before executing this file, make sure all the nescessary dirs exist,
#       and the $DOTFOLDER variable is correct.
##############################################################################
$DOTFOLDER="$HOME/.dots"

ln -s "$DOTFOLDER/bashrc" "$HOME/.bashrc"
ln -s "$DOTFOLDER/bin" "$HOME/.bin"
ln -s "$DOTFOLDER/dircolors" "$HOME/.dircolors"
ln -s "$DOTFOLDER/fonts.conf" "$HOME/.fonts.conf"
ln -s "$DOTFOLDER/htoprc" "$HOME/.htoprc"
ln -s "$DOTFOLDER/irssi" "$HOME/.irssi"
ln -s "$DOTFOLDER/mpd" "$HOME/.config/mpd"
ln -s "$DOTFOLDER/mplayer" "$HOME/.mplayer"
ln -s "$DOTFOLDER/ncmpcpp" "$HOME/.ncmpcpp"
ln -s "$DOTFOLDER/pentadactyl" "$HOME/.pentadactyl"
ln -s "$DOTFOLDER/pentadactylrc" "$HOME/.pentadactylrc"
ln -s "$DOTFOLDER/screenrc" "$HOME/.screenrc"
ln -s "$DOTFOLDER/vim" "$HOME/.vim"
ln -s "$DOTFOLDER/vimrc" "$HOME/.vimrc"
ln -s "$DOTFOLDER/Xdefaults" "$HOME/.Xdefaults"
ln -s "$DOTFOLDER/xinitrc" "$HOME/.xinitrc"
ln -s "$DOTFOLDER/xmonad/bitmaps" "$HOME/.xmonad/bitmaps"
ln -s "$DOTFOLDER/xmonadrc" "$HOME/.xmonad/xmonad.hs"
ln -s "$DOTFOLDER/zshrc" "$HOME/.zshrc"
ln -s "$DOTFOLDER/dwm" "/home/meatcar/.dots/.dwm"
