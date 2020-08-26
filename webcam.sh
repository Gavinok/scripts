#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : webcam.sh
# @created     : Wed 22 Jul 2020 10:47:50 PM
#
# @description : simple webcam display
######################################################################

droidcam-cli adb 4747 &
mpv av://v4l2:/dev/video0 --no-osc --profile=low-latency --untimed --geometry=-1920-1080 --autofit=30% --no-resume-playback

# pkill -f /dev/video || mpv --no-osc --no-input-default-bindings --input-conf=/dev/null --geometry=-0-0 --autofit=30%  --title="mpvfloat" /dev/video0

# vim: set tw=78 ts=2 et sw=2 sr:

