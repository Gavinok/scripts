#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : textbook.sh
# @created     : Sun 12 Jan 2020 01:00:06 AM MST
#
# @description : script for finding textbooks online fast
######################################################################

textbook=$(echo "textbook name" | dmenu -p "textbook")
$BROWSER "http://gen.lib.rus.ec/search.php?req=$textbook"
# vim: set tw=78 ts=2 et sw=2 sr:
