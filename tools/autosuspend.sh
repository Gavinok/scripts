#!/bin/sh
pidof -s xautolock >& /dev/null
if [ $? -ne 0 ]; then
  xautolock -time 60 -locker "systemctl suspend" &
fi
