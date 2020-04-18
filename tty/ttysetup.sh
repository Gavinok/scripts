#!/bin/sh
if [ "$TERM" = "linux" ]; then
	# echo -en "\e]P0232323" #black
	# echo -en "\e]P82B2B2B" #darkgrey
	# echo -en "\e]P1D75F5F" #darkred
	# echo -en "\e]P9E33636" #red
	# echo -en "\e]P287AF5F" #darkgreen
	# echo -en "\e]PA98E34D" #green
	# echo -en "\e]P3D7AF87" #brown
	# echo -en "\e]PBFFD75F" #yellow
	# echo -en "\e]P48787AF" #darkblue
	# echo -en "\e]PC7373C9" #blue
	# echo -en "\e]P5BD53A5" #darkmagenta
	# echo -en "\e]PDD633B2" #magenta
	# echo -en "\e]P65FAFAF" #darkcyan
	# echo -en "\e]PE44C9C9" #cyan
	# echo -en "\e]P7E5E5E5" #lightgrey
	# echo -en "\e]PFFFFFFF" #white
	# echo -e "\e[?112c"
	# clear #for background artifacting
	_SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
	for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
		echo -en "$i"
	done
	clear
	# Switch escape and caps if tty:
	sudo -n loadkeys ~/.scripts/tty/ttymaps.kmap 2>/dev/null
fi
