#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : tsstart.sh
# @created     : Sat 29 Feb 2020 01:51:08 PM
#
# @description : start executing enqued commands
######################################################################

pipename=ts.pipe
pipefile="/tmp/${pipename}"
lockfile="/tmp/ts.lock"
[ ! -p "${pipefile}" ] && exit

# quit if lockfile already exists
[ -f "${lockfile}" ] && exit

touch "${lockfile}" &&  sh < "${pipefile}" 
rm "${lockfile}"

notify-send "tasks completed"
# vim: set tw=78 ts=2 et sw=2 sr:
