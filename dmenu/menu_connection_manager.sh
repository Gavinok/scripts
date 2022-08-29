#!/bin/sh

# initial configuration
# sudo pacman --noconfirm -S bluez-utils pulseaudio-bluetooth pulseaudio-alsa blueman
# sudo ln -vsf ${PWD}/etc/bluetooth/main.conf /etc/bluetooth/main.conf
# sudo systemctl start bluetooth.service
# sudo systemctl enable bluetooth.service

# Requires:
# 		blueman
# 		bluez-utils
# 		networkmanager_dmenu (https://github.com/firecat53/networkmanager-dmenu)
# 		btmenu               (https://github.com/cdown/btmenu)

[ "$(cat /sys/class/net/w*/operstate)" = 'down' ] && wifiicon="📡"
[ -z "${wifiicon+var}" ] && wifiicon=$(grep "^\s*w" /proc/net/wireless | awk '{ print "📶", int($3 * 100 / 70) "%" }')
# WIFI=$(printf "%s " "$wifiicon" && nmcli connection show --active | sed '1d'  | awk '{print $1}')

WIFI=$(printf "%s %s" "${wifiicon}" "$(cat /sys/class/net/w*/operstate | sed "s/down/❎/;s/up/🌐/")")

if [ -n "${WIFI}" ]; then
	choice=$(printf 'Bluetooth\nNetwork' | dmenu -i -p "${WIFI}")
else
	choice=$(printf 'Bluetooth\nNetwork' | dmenu -i -p 'Connect:')
fi

if [ "${choice}" = "Bluetooth" ]; then
	sudo rkill unblock bluetooth

	# start blueman-applet if needed
	blueman-applet &
	# [ -z "$(pgrep blueman)" ] && blueman-applet &

	choice2=$(printf 'Connect\nNew\nManage\nDisable' | dmenu -i -p 'Bluetooth:')
	[ "${choice2}" = 'Connect' ] && btmenu
	[ "${choice2}" = 'New' ] && $TERMINAL bluetoothctl
	[ "${choice2}" = 'Manage' ] && $TERMINAL bluetoothctl
	[ "${choice2}" = 'Disable' ] && sudo rkill block bluetooth

	# since bluman-applet is nolonger needed to maintain connections
fi
if [ "${choice}" = "Network" ]; then
	networkmanager_dmenu
fi
#vim:ft=sh
