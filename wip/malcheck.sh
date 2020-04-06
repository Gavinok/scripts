#!/bin/sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : malcheck.sh
# @created     : Thu 09 Jan 2020 03:25:47 PM MST
#
# @description : check the number of watched episodes of an anime using fzf
#                and curl.
######################################################################

#===  FUNCTION  ======================================================
#         NAME: format
#  DESCRIPTION: formats json output
#=====================================================================
format() {
  echo "$*" | python -m json.tool
}

listtitle() {
  jq '.anime[] | .title'
}


watching=$(curl -s https://api.jikan.moe/v3/user/gswag/animelist/watching |
  jq '.anime[] | .title, .watched_episodes, .total_episodes')

echo $watching

# echo $watching 

# vim: set tw=78 ts=2 et sw=2 sr:

