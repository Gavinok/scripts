#!/bin/bash

checkwificonnect(){ \
	test=$(ip addr | grep "state UP")
	test2=$(wifi | grep "on")
	if [ -z "$test" && -z "$test2" ] 
	then
		return
	fi
	kdeconnect-cli &
}
checkbluetooth(){ \
	test=$(bluetooth | grep "on")
	if [ -z "$test" ] 
	then
		return
	fi
	blueman-applet&
}
checkcompton(){ \
	test=$(pgrep "compton")
	if [ -z "$test" ] 
	then
		return
	fi
	flashfocus &
}


xautolock -time 15 -locker '~/.script/savebat.sh' &
~/.scripts/remaps &
~/.fehbg &
compton &
unclutter &
sudo powertop --auto-tune &
clipmenud &
~/.scripts/rldkeynav &
redshift &
pulsemixer --set-volume 50 &
checkcompton
sleep 10
checkwifi
checkbluetooth
