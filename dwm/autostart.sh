#!/bin/sh
dock_monitor 
killall dwm
scheme=$(cat ~/.config/colorschemes/current)
if [ "$scheme" = "dark" ];then
    picom &
    flashfocus &
fi
unclutter &
clipmenud &
# redshift &
# pulsemixer --set-volume 50 &
xbacklight -set 30 &
autosuspend.sh  &
# sudo rkill block bluetooth &
dunst &
# echo 'auto' | sudo tee '/sys/bus/usb/devices/4-1/power/control' &
# disable Ethernet
# sudo ip link set enp0s25 down &
# sudo powertop --auto-tune &
sudo wpa_supplicant -B -i wls1 -c /etc/wpa_supplicant.conf && sudo dhclient wls1 && notify-send "successfully connected"
setsid syncthing --no-browser &
device=$(uname -n)
[ "$device" = "sp4" ] && exit
sleep 10
# psave.sh &
# covid19.sh &
