#!/bin/bash
# Simple dmenu based program that utilizes systemd 

LAUNCER="dmenu"

res=$(printf "shutdown\\nreboot\\nhibernate\\nkill X" | ${LAUNCER} -i -p 'Power Menu:'  ) 

# ensure that no packages are being installed
# check for pacman and yay
[ -f /var/lib/pacman/db.lck ] && notify-send "ERROR /var/lib/pacman/db.lck exists\n pacman in use" && exit 2
# check for pip
pgrep -x pip   && "ERROR pip in use"   && exit 3
# check for yarn
pgrep -x yarn  && "ERROR yarn in use"  && exit 4
# check for pip
pgrep -x npm   && "ERROR yarn in use"  && exit 5
# check for brew
pgrep -x brew  && "ERROR brew in use"  && exit 5
# check for cargo
pgrep -x cargo && "ERROR cargo in use" && exit 6

case "${res}" in
	"reboot" )
		systemctl reboot
		;;
	"shutdown" )
		systemctl poweroff
		;;
	"hibernate" )
		systemctl hibernate
		;;
	"kill X" )
		killall Xorg
		;;
	*)
		exit 1
		;;	
esac
exit 0
#vim:ft=sh
