#!/bin/sh 
##############################################################################
# Reinstate all the dotfiles into their functional locations.
#
# NOTE: make sure and the DOTS variable is correct.
##############################################################################
DOTS="$PWD"
ln -rs 'ackrc' ~/'.ackrc'
ln -rs 'bashrc' ~/'.bashrc'
ln -rs 'bin' ~/'bin'
ln -rs 'bspwm' ~/'.config/bspwm'
ln -rs 'dircolors' ~/'.dircolors'
ln -rs 'fonts' ~/'.fonts'
ln -rs 'gitconfig' ~/'.gitconfig'
ln -rs 'htoprc' ~/'.htoprc'
ln -rs 'i3/blocks' ~/'.config/i3blocks'
ln -rs 'i3' ~/'.i3'
ln -rs 'irssi' ~/'.irssi'
ln -rs 'login' ~/'.login'
ln -rs 'mpd' ~/'.config/mpd'
ln -rs 'mplayer' ~/'.mplayer'
ln -rs 'ncmpcpp' ~/'.ncmpcpp'
ln -rs 'npmrc' /home/meatcar/'.npmrc'ln -rs 'bspwm' ~/'.config/bspwm'
ln -rs 'pentadactyl' ~/'.pentadactyl'
ln -rs 'pentadactylrc' ~/'.pentadactylrc'
ln -rs 'screenrc' ~/'.screenrc'
ln -rs 'spacemacs' /home/meatcar/'.spacemacs'
ln -rs 'sxhkd' ~/'.config/sxhkd'
ln -rs 'systemd_user' /home/meatcar/'.config/systemd'
ln -rs 'twmn' /home/meatcar/'.config/twmn'
ln -rs 'uzbl/config' ~/'.config/uzbl'
ln -rs 'uzbl/local' ~/'.local/share/uzbl'
ln -rs 'vimrc' ~/'.vimrc'
ln -rs 'vim' ~/'.vim'
ln -rs 'weechat' /home/meatcar/'.weechat'
ln -rs 'Xdefaults' ~/'.Xdefaults'
ln -rs 'xinitrc' ~/'.xinitrc'
ln -rs '~/.xsessionrc' ~/'.login'
ln -rs 'zshrc' ~/'.zshrc'
