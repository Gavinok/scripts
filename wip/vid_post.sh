#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : vid_post.sh
# @created     : Thu 04 Feb 2021 02:20:33 PM
#
# @description : 
######################################################################

videofile=$1
outfile=MONO${videofile}
ffmpeg -i "$videofile" -ac 1 "${outfile}"

# vim: set tw=78 ts=2 et sw=2 sr:

