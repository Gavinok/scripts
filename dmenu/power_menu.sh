#!/bin/bash
# Simple dmenu based program that utilizes systemd 

LAUNCER="dmenu"

res=$(printf "shutdown\\nreboot\\nhibernate" | $LAUNCER -i -p 'Power Menu:'  ) 
if [ $res = "reboot" ]; then
    systemctl reboot
fi
if [ $res = "shutdown" ]; then
    systemctl poweroff
fi
if [ $res = "hibernate" ]; then
    systemctl hibernate
fi
exit 0
