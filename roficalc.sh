#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : roficalc.sh
# @created     : Sat 11 Jan 2020 09:15:22 PM MST
#
# @description : wraper for rofi-calc and xclip
######################################################################

rofi -show calc -modi calc -no-show-match -no-sort -calc-command "echo '{result}' | xclip"

# vim: set tw=78 ts=2 et sw=2 sr:
