#! /usr/bin/env sh
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


SCREENSHOTDIR="${HOME}/Pictures/ScreenShots"

print_date(){
	date '+%F_%T'
}

mkdir -p "${SCREENSHOTDIR}"

while getopts ":cw" o; 
do 
	case "${o}" in
		c) import "${SCREENSHOTDIR}/$(print_date).png" ;;
		w) import -window "$(xdotool getactivewindow)" "${SCREENSHOTDIR}/$(print_date).png" ;;
		\?) printf "Invalid option: -%s\\n" "${o}" && exit ;;
		*)
	esac
done

case "$(printf "a selected area\\ncurrent window\\nfull screen" | dmenu -l 6 -i -p "Screenshot which area?")" in
	"a selected area") import "${SCREENSHOTDIR}/$(print_date).png" ;;
	"current window") import -window "$(xdotool getactivewindow)" "${SCREENSHOTDIR}/$(print_date).png" ;;
	"full screen") import -window root "${SCREENSHOTDIR}/$(print_date).png" ;;
	*) exit;;
esac
notify-send screanshot taken
