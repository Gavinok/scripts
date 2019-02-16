#!/bin/bash

choice=$(printf "Bluetooth\\nNetwork" | dmenu -i -p 'Connect:'  ) 

if [ $choice = "Bluetooth" ]; then
	blueman-manager
fi
if [ $choice = "Network" ]; then
	networkmanager_dmenu
fi
