#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : covid19.sh
# @created     : Tue 24 Mar 2020 09:29:35 PM
#
# @description : Simple script to get the death percentage for COVID-19
#                every hour
######################################################################

stats=$(curl -s https://corona.lmao.ninja/countries/canada)
deaths=$(echo "${stats}" | jq '.deaths')
cases=$(echo "${stats}" | jq '.cases')
deathrate='🤒 '$(echo "(${deaths}" /  "${cases}) * 100" | bc -l | cut -c -3)'% death rate in Canada from COVID-19'
notify-send "${deathrate}"

# vim: set tw=78 ts=2 et sw=2 sr:
