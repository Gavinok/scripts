#!/bin/bash
# Simple dmenu based program that utilizes systemd

LAUNCER="dmenu -i -p"

# ensure that no packages are being installed
# check for pacman and yay
[ -f /var/lib/pacman/db.lck ] && notify-send --urgency=critical "❕[ERROR] /var/lib/pacman/db.lck exists pacman in use" && exit 2

progcheck() {
	pgrep -x "${1}" >/dev/null && notify-send --urgency=critical "❕[ERROR] $1 in use" && exit 1
}


res=$(printf 'shutdown\nreboot\nsleep\nhibernate\nkill X' | ${LAUNCER} 'Power Menu:')

# check for running programs
progcheck pip
progcheck pacman
progcheck yay
progcheck apt
progcheck yarn
progcheck npm
progcheck rustc
progcheck brew
progcheck cargo
progcheck rclone
progcheck rsync

case "${res}" in
"reboot")
	systemctl reboot
	;;
"shutdown")
	systemctl poweroff
	;;
"sleep")
	systemctl suspend
	;;
"hibernate")
	systemctl hibernate
	;;
"kill X")
	killall Xorg
	;;
*)
	exit 1
	;;
esac
exit 0
#vim:ft=sh
