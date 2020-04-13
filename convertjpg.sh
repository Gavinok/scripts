#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : convertjpg.sh
# @created     : Sat 11 Apr 2020 01:06:00 PM
#
# @description : 
######################################################################
for file in *.jpg; do
    echo convert "$file" $(echo "$file" | sed 's/\.jpg$/\.eps/')
done
# vim: set tw=78 ts=2 et sw=2 sr:

