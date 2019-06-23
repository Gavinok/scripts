#!/bin/dash
checkbluetooth(){ \
	test=$(bluetooth | grep "on")
	if [ -z "$test" ] 
	then
		return
	fi
	blueman-applet&
}
dock_monitor 
compton &
unclutter &
clipmenud &
kdeconnect-cli &
dropbox-cli start &
redshift &
pulsemixer --set-volume 50 &
xbacklight -set 50 &
flashfocus &
sudo powertop --auto-tune --quiet &
# sleep 1
# checkbluetooth &
