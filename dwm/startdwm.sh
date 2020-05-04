#!/bin/sh
# Infinitely restart dwm so no programs close
while true; do
    # Log stderror to a file 
    # dwm 2>> /tmp/dwm.log
    # No error logging
    dwm >/dev/null 2>&1
done
