#!/bin/bash
# utilises dunstify ant amixer to notify the 
# user of the volume as well as chang it
# volume="$(amixer -D pulse get Master | awk '$2== "Left:" {print $5}')"
volume="$(pactl list sinks | grep 'Mute: yes')"
[ -n "$volume" ] &&  /usr/bin/dunstify -r 798 -t 500 "🔈 MUTE" && exit
volume="$(pactl list sinks | grep -m 1 'Volume:' | cut -d/ -f2)"
	/usr/bin/dunstify -r 798 -t 500 "🔊 ${volume}"
