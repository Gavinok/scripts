#!/bin/sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : covid19.sh
# @created     : Tue 24 Mar 2020 09:29:35 PM
#
# @description : Simple script to get the death percentage for COVED-19
#                every hour
######################################################################

country=Canada

stats=$(curl -s "https://corona-stats.online/${country}/?source=2&format=json" | jq '.data[]')
deaths=$(echo "${stats}" | jq '.deaths')
cases=$(echo "${stats}" | jq '.cases')
deathrate=''$(echo "(${deaths}" / "${cases}) * 100" | bc -l | cut -c -3)'%'
deathrate=$(printf "😷 Cases:  %s
💀 Deaths: %s

%s 💀/😷 in Canada
form COVID-19" "${cases}" "${deaths}" "${deathrate}")
notify-send "${deathrate}"

# vim: set tw=78 ts=2 et sw=2 sr:
