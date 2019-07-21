#!/bin/bash
# Simple dmenu based program that utilizes systemd 

LAUNCER="dmenu"

res=$(printf "shutdown\\nreboot\\nhibernate\\nkill X" | $LAUNCER -i -p 'Power Menu:'  ) 
case "$res" in
    "reboot" )
    systemctl reboot
	;;
    "shutdown" )
    systemctl poweroff
	;;
    "hibernate" )
    systemctl hibernate
	;;
    "kill X" )
    killall Xorg
	;;
esac
exit 0
