#!/bin/dash

[ "$(cat /sys/class/net/w*/operstate)" = 'down' ] && wifiicon="📡"
[ ! -n "${wifiicon+var}" ] && wifiicon=$(grep "^\s*w" /proc/net/wireless | awk '{ print "📶", int($3 * 100 / 70) "%" }')
# WIFI=$(printf "%s " "$wifiicon" && nmcli connection show --active | sed '1d'  | awk '{print $1}')

WIFI=$(printf "%s %s" "$wifiicon" "$(cat /sys/class/net/w*/operstate | sed "s/down/❎/;s/up/🌐/")")




if [ -n "$WIFI" ]; then
   choice=$(printf "Bluetooth\\nNetwork" | dmenu -i -p "$WIFI"  ) 
else 
    choice=$(printf "Bluetooth\\nNetwork" | dmenu -i -p 'Connect:'  ) 
fi


if [ $choice = "Bluetooth" ]; then
	# [ -z $(pgrep blueman) ] && blueman-applet&
	choice2=$(printf "Connect\\nNew\\nManage" | dmenu -i -p 'Bluetooth:'  ) 
	[ $choice2 = 'Connect' ] && btmenu
	[ $choice2 = 'New' ] && blueman-assistant
        [ $choice2 = 'Manage' ] && blueman-manager
fi
if [ $choice = "Network" ]; then
	networkmanager_dmenu
fi
#vim:ft=sh
