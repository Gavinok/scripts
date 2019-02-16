#!/bin/bash
print_date(){
	date '+%F_%T'

}
maim -i $(xdotool getactivewindow) ~/Pictures/ScreenShots/$(print_date).png
notify-send screanshot taken
