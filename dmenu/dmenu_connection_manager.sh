#!/bin/bash

choice=$(printf "Bluetooth\\nNetwork" | dmenu -i -p 'Connect:'  ) 

if [ $choice = "Bluetooth" ]; then
	[ -z $(pgrep blueman) ] && blueman-applet&
	choice2=$(printf "Connect\\nManage" | dmenu -i -p 'Bluetooth:'  ) 
	if [ choice2 == "Connect" ];then
		blueman-assistant
	else
		blueman-manager
	fi
fi
if [ $choice = "Network" ]; then
	networkmanager_dmenu
fi
