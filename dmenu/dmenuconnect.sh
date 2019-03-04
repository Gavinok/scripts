#!/bin/bash

choice=$(printf "Bluetooth\\nNetwork" | dmenu -i -p 'Connect:'  ) 

if [ $choice = "Bluetooth" ]; then
	if [ -z pgrep blueman ]; then
		blueman-applet&
		sleep 3
		blueman-manager
		exit 1
	fi
	blueman-manager
fi
if [ $choice = "Network" ]; then
	networkmanager_dmenu
fi
