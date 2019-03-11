export PATH=/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH:/home/meatcar/.bin/

if [[ $TERMINIX_ID ]]; then
  source /etc/profile.d/vte.sh
fi

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
