#!/bin/dash
dock_monitor 
killall dwm
scheme=$(cat ~/.config/colorschemes/current)
# if [ "$scheme" = "dark" ];then
#     compton &
#     flashfocus &
# fi
unclutter &
clipmenud &
# redshift &
pulsemixer --set-volume 50 &
xbacklight -set 30 &
autosuspend.sh  &
sudo rkill block bluetooth &
dunst &
# echo 'auto' | sudo tee '/sys/bus/usb/devices/4-1/power/control' &
# disable Ethernet
# sudo ip link set enp0s25 down &
sudo powertop --auto-tune &
device=$(uname -n)
[ "$device" = "sp4" ] && exit
sleep 10
psave.sh &
# covid19.sh &
