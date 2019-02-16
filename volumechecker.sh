#!/bin/bash


volume="$(amixer -D pulse get Master | awk '$2== "Left:" {print $5}')"
# if test "$volume" -gt 0 
# then
	/usr/bin/dunstify -r 798 -t 500 "🔊  ${volume}"

# else
	# /usr/bin/dunstify -r 798 -t 500 "🔈 [Mute]"
# fi
