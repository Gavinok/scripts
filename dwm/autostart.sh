#!/bin/sh
dock_monitor 
killall dwm
scheme=$(cat ~/.config/colorschemes/current)
if [ "$scheme" = "dark" ];then
    picom --experimental-backends &
    flashfocus &
fi
unclutter &
clipmenud &

#       LATITUDE:LONGITUDE &
redshift -l 60:-135 &

# pulsemixer --set-volume 50 &
xbacklight -set 30 &
autosuspend.sh  &
# sudo rkill block bluetooth &
dunst &
# echo 'auto' | sudo tee '/sys/bus/usb/devices/4-1/power/control' &
# disable Ethernet
# sudo ip link set enp0s25 down &
# sudo powertop --auto-tune &
# sudo wpa_supplicant -B -i wls1 -c /etc/wpa_supplicant.conf && sudo dhclient wls1 && notify-send "successfully connected"
remaps 2>/dev/null &
setsid syncthing --no-browser &
device=$(uname -n)
[ "$device" = "sp4" ] && exit
sleep 10
# psave.sh &
# covid19.sh &
# remind -z -k'notify-send 🦄\ [REMINDER]:\ %s" &' "${DOTREMINDERS}" &
