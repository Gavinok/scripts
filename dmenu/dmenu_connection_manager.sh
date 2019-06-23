#!/bin/dash

WIFI=$(nmcli connection show --active | sed '1d'  | awk '{print $1}')

if [ -n "$WIFI" ]; then
   choice=$(printf "Bluetooth\\nNetwork" | dmenu -i -p "wifi: $WIFI"  ) 
else 
    choice=$(printf "Bluetooth\\nNetwork" | dmenu -i -p 'Connect:'  ) 
fi


if [ $choice = "Bluetooth" ]; then
	[ -z $(pgrep blueman) ] && blueman-applet&
	choice2=$(printf "Connect\\nNew\\nManage" | dmenu -i -p 'Bluetooth:'  ) 
	[ $choice2 = 'Connect' ] && btmenu
	[ $choice2 = 'New' ] && blueman-assistant
        [ $choice2 = 'Manage' ] && blueman-manager
fi
if [ $choice = "Network" ]; then
	networkmanager_dmenu
fi
