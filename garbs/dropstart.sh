#!/bin/sh
USER=''your_user''
status=$2
case $status in
       up)
		su -c 'DISPLAY=:0 /usr/bin/dropbox & ' $USER
       ;;
       down)
       		killall dropbox
       ;;
esac

