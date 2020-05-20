#!/bin/sh
#===============================================================================
#         FILE: windowshot.sh
#
#  DESCRIPTION: Takes a screanshot using imagemagic and xprop
#
#       AUTHOR: Gavin Jaeger-Freeborn gavinfreeborn@gmail.com
#      CREATED: Thu 28 Nov 2019 12:28:36 PM MST
#      VERSION: 1.0
#===============================================================================

# This is bound to Shift+PrintScreen by default, requires maim. It lets you
# choose the kind of screenshot to take, including copying the image or even
# highlighting an area to copy. scrotcucks on suicidewatch right now.

print_date() {
	date '+%F_%T'
}

SCREENSHOTDIR="${HOME}/Pictures/ScreenShots"
SCREENSHOTNAME="${SCREENSHOTDIR}/$(print_date).png"

note() {
	notify-send "screenshot name ${SCREENSHOTNAME}"
}

mkdir -p "${SCREENSHOTDIR}"


region() { 
	killall unclutter
	import "${SCREENSHOTNAME}" 
	setsid unclutter &
}
window() { import -window "$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')" "${SCREENSHOTNAME}" ;}
root()   { import -window root "${SCREENSHOTNAME}" ;}

# Default Prompt For Selection
prompter(){
	case "$(printf 'a selected area\ncurrent window\nfull screen' | dmenu -l 6 -i -p "Screenshot which area?")" in
		"a selected area") region ;;
		"current window") window ;;
		"full screen") rootwin ;;
		*) exit ;;
	esac
}

while getopts ":cw" o; do
	case "${o}" in
		c) region;;
		w) window ;;
		r) root ;;
		\?) printf 'Invalid option: -%s\n' "${o}" && exit ;;
		*) prompter ;;
	esac
done

note

${PLUMBER:-xdg-open} "${SCREENSHOTNAME}"
