#!/bin/bash
 
# res=$(printf "lock\\nlogout\\nreboot\\nshutdown\\nhibernate" | dmenu -i -p 'Power Menu:'  ) 
res=$(printf "shutdown\\nreboot\\nhibernate" | dmenu -i -p 'Power Menu:'  ) 
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
