#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : webcam.sh
# @created     : Wed 22 Jul 2020 10:47:50 PM
#
# @description : simple webcam display
######################################################################

droidcam-cli adb 4747 &
mpv av://v4l2:/dev/video0 --profile=low-latency --untimed

# vim: set tw=78 ts=2 et sw=2 sr:

