#!/bin/bash

choice=$(printf "Bluetooth\\nNetwork" | dmenu -i -p 'Connect:'  ) 

if [ $choice = "Bluetooth" ]; then
	[ -z $(pgrep blueman) ] && blueman-applet&
	choice2=$(printf "Connect\\nManage" | dmenu -i -p 'Bluetooth:'  ) 
	[ $choice2 = 'Connect' ] && blueman-assistant
        [ $choice2 = 'Manage' ] && blueman-manager
fi
if [ $choice = "Network" ]; then
	networkmanager_dmenu
fi
