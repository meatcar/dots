export PATH=/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH:/home/meatcar/.bin/

if [[ $TERMINIX_ID ]]; then
  source /etc/profile.d/vte.sh
fi

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
if [ -e /home/meatcar/.nix-profile/etc/profile.d/nix.sh ]; then . /home/meatcar/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
