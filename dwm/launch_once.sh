#!/bin/dash

# a simple script for starting a program 
# kill it if it is already running
if  pgrep -x "$1" ;then
	killall "$1"
	# for program that dont imediatly close
	xdotool windowclose "$(xdotool search --name "$1")"
	exit
fi
exec "$1"
#vim:ft=sh
