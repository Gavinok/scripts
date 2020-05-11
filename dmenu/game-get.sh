#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : textbook.sh
# @created     : Sun 12 Jan 2020 01:00:06 AM MST
#
# @description : script for finding textbooks online fast
######################################################################

gamename=$(echo '🎮' | dmenu -p 'Game Name')
page=$(curl 'https://www.gamestorrents.nu/?s=final+fantasy') 
system=$(printf 'psp\nnds\nps3\nxbox360\npc\nps2\nwii\nmac' | dmenu -l 8 -p 'Game system' )
echo $system
gamelist=$(echo $page | grep 'https://www.gamestorrents.nu' | grep -v '<img' |grep -v '\.js' | grep "<td><a href=\"https://www.gamestorrents.nu/juegos-${system}")
echo $gamelist
game=$(echo $gamelist | cut -d'>' -f 3  | sed 's/<\/a//g' | dmenu -l 5)
www "$(echo $gamelist | grep -F "$game" | cut -d '"' -f 2)"
$BROWSER "https://www.gamestorrents.nu/?s=$gamename"
# vim: set tw=78 ts=2 et sw=2 sr:
