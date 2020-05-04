#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : fromphone.sh
# @created     : Tue 28 Apr 2020 12:34:38 PM
#
# @description : open url from phone
######################################################################


mkdir -p "/tmp/$(echo "$1" | sed "s/.*\///")"

qrcp receive "/tmp/$(echo "$1" | sed "s/.*\///")"

cat "/tmp/$(echo "$1" | sed "s/.*\///")" > xclip -i

rm -r "/tmp/$(echo "$1" | sed "s/.*\///")"/

# vim: set tw=78 ts=2 et sw=2 sr:
