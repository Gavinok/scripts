#!/bin/sh
#===============================================================================
#         FILE: windowshot.sh
#
#  DESCRIPTION: Takes a screanshot using imagemagic and xdotool
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

while getopts ":cw" o; do
	case "${o}" in
	c) import "${SCREENSHOTNAME}" && note && exit ;;
	w) import -window "$(xdotool getactivewindow)" "${SCREENSHOTNAME}" && note && exit ;;
	\?) printf 'Invalid option: -%s\n' "${o}" && exit ;;
	*) ;;
	esac
done

case "$(printf 'a selected area\ncurrent window\nfull screen' | dmenu -l 6 -i -p "Screenshot which area?")" in
"a selected area") import "${SCREENSHOTNAME}" ;;
"current window") import -window "$(xdotool getactivewindow)" "${SCREENSHOTNAME}" ;;
"full screen") import -window root "${SCREENSHOTNAME}" ;;
*) exit ;;
esac
note
