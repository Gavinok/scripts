#!/bin/bash

#!/bin/sh

# This script simplifies dropdown windows in i3.
# Shows/hides a scratchpad of a given name, if it doesn't exist, creates it.
# Usage:
#	argument name: script to run in dropdown window
#	all other args are interpreted as options for your terminal
# My usage:
#	ddpawn
# bindsym $mod+u	exec --no-startup-id ddspawn tmuxdd
#	Will hide/show window running the `tmuxdd` script when I press mod+u in i3
# bindsym $mod+a	exec --no-startup-id ddspawn dropdowncalc -f mono:pixelsize=24
#	Similar to above but with `dropdowncalc` and the other args are interpretated as for my terminal emulator (to increase font)


name=$RANDOM

[ -z "$name" ] && exit

if xwininfo -tree -root | grep "(\"$name\" ";
then
	echo "Window detected."
else
	echo "Window not detected... spawning."
	i3 "[instance=\"$name\"] floating enable; [instance=\"$name\"] move position center" && i3 "exec --no-startup-id $TERMINAL -n $name"
#move position
	sleep .25 # This sleep is my laziness, will fix later (needed for immediate appearance after spawn).
fi
i3 "[instance=\"$name\"] floating enable; [instance=\"$name\"] move position center"

