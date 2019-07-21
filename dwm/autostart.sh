#!/bin/dash
dock_monitor 
# included in dock_monitor
# remaps &
# setbg &
killall dwm
compton &
unclutter &
clipmenud &
kdeconnect-cli &
dropbox-cli start &
redshift &
pulsemixer --set-volume 50 &
xbacklight -set 50 &
flashfocus &
autosuspend.sh  &
psave.sh &
sleep 15
checkup &
# mailsync &
newsup &
