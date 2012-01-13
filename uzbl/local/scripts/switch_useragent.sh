#!/bin/sh

[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/uzbl" ] || exit 1
file=${XDG_DATA_HOME:-$HOME/.local/share}/uzbl/user_agents.txt

COLORS=" -nb #303030 -nf khaki -sb #CCFFAA -sf #303030"
if dmenu --help 2>&1 | grep -q '\[-rs\] \[-ni\] \[-nl\] \[-xs\]'
then
	DMENU="dmenu -i -xs -rs -l 10" # vertical patch
else
	DMENU="dmenu -i -l 10" # horizontal, oh well!
fi

if [ -z "$8" ] ; then
	new_agent=`grep -v '^[[:space:]#]' $file | $DMENU $COLORS | perl -p -e 's/^.*?: ?//'`
else
	new_agent=`grep "^$8:" $file | perl -p -e 's/^.*?: ?//'`
	[ -z "$new_agent" ] && exit 1
fi
echo "set useragent = $new_agent" > $UZBL_FIFO
echo "reload" > $UZBL_FIFO # Reload the page so the new user agent is used.
