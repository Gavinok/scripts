#!/bin/sh
dock_monitor
scheme=$(cat ~/.config/colorschemes/current)
# if [ "$scheme" = "dark" ];then
picom &
flashfocus &
# fi
# unclutter &
clipmenud &
#            DAY:NIGHT  LAT:LON
redshift -t 6500:2500 -l 60:-135 &
# pulsemixer --set-volume 50 &
xbacklight -set 30 &
autosuspend.sh &
# sudo rkill block bluetooth &
dunst &
# echo 'auto' | sudo tee '/sys/bus/usb/devices/4-1/power/control' &
# disable Ethernet
# sudo ip link set enp0s25 down &
# sudo powertop --auto-tune &
# sudo wpa_supplicant -B -i wls1 -c /etc/wpa_supplicant.conf && sudo dhclient wls1 && notify-send "successfully connected"
if [ -e /usr/lib/kdeconnectd ]; then
    setsid /usr/lib/kdeconnectd &
fi

statwe &
blueman-applet &
dbus-update-activation-environment &
# startlemon.sh  | lemonbar -f "monospace" -f "Symbols Nerd Font-10" &
# xbindkeys &
remaps 2>/dev/null &
# setsid syncthing --no-browser &
device=$(uname -n)
# xinput disable "Elan Touchpad"
[ "$device" = "sp4" ] && exit
# psave.sh &
# covid19.sh &
# remind -z -k'notify-send 🦄\ [REMINDER]:\ %s" &' "${DOTREMINDERS}" &
# xinput set-prop 'Elan TrackPoint' 'Coordinate Transformation Matrix' \
#        9.0 0.0 0.0 0.0 9.0 0.0 0.0 0.0 1.0
