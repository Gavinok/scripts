#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : fzbm.sh
# @created     : Mon 30 Mar 2020 12:41:31 PM
#
# @description : use fzf to open a bookmark
######################################################################

BOOKMARKS="${HOME}/.config/bookmarks"

cat $BOOKMARKS | fzf | xargs -I '{}' xdg-open '{}'

# vim: set tw=78 ts=2 et sw=2 sr:

