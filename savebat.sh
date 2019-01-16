#!/bin/bash

# [ "$(cat /sys/class/power_supply/BAT0/status)" = "Charging" ] && notify-send "here" && exit
	
 /usr/bin/systemctl hibernate

