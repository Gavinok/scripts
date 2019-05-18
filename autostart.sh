#!/bin/sh
checkbluetooth(){ \
	test=$(bluetooth | grep "on")
	if [ -z "$test" ] 
	then
		return
	fi
	blueman-applet&
}
~/.fehbg &
~/.scripts/remaps &
compton &
unclutter &
clipmenud &
kdeconnect-cli &
# ~/.scripts/rldkeynav &
dropbox-cli start &
redshift &
pulsemixer --set-volume 50 &
xbacklight -set 50 &
flashfocus &
sudo powertop --auto-tune --quiet &
# sleep 1
# checkbluetooth &
