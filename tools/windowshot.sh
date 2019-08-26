#!/bin/bash
# Quickly captures what ever is displayed in the
# currently focused window
print_date(){
	date '+%F_%T'

}
xscreen -uf ~/Pictures/ScreenShots/"$(print_date)".png
notify-send screanshot taken
