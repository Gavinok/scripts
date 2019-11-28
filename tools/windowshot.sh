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

while getopts ":rw" o; 
do 
	case "$o" in
		r) opts='-window root';;
		w) opts="-window $(xdotool getactivewindow)";;
		\?) printf "Invalid option: -%s\\n" "$o" && exit ;;
	esac
done

print_date(){
	date '+%F_%T'

}

mkdir -p "$HOME/Pictures/ScreenShots"
if [ -z "$opts" ]; then
	import "$HOME/Pictures/ScreenShots/$(print_date).png"
else
	import $opts "$HOME/Pictures/ScreenShots/$(print_date).png"
fi
notify-send screanshot taken
