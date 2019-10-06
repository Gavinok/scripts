#!/bin/dash
dock_monitor 
# included in dock_monitor
# remaps &
# setbg &
killall dwm
scheme=$(cat ~/.config/colorschemes/current)
if [ "$scheme" = "dark" ];then
    compton &
    flashfocus &
fi
unclutter &
clipmenud &
kdeconnect-cli &
dropbox-cli start &
redshift &
pulsemixer --set-volume 50 &
xbacklight -set 30 &
autosuspend.sh  &
device=$(uname -n)
[ "$device" = "sp4" ] && exit
