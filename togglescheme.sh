#!/usr/bin/env bash
scheme="light"
#Xresources
cp ~/.config/colorschemes/xresources/$scheme ~/.config/colorschemes/xresources/current
xrdb ~/.Xresources
#dwm
cp ~/.config/colorschemes/dwm/$scheme.c ~/.config/colorschemes/dwm/current.c
cd ~/.config/dwm/
sudo make clean install
killall dwm
#dmenu
cp ~/.config/colorschemes/dmenu/$scheme.c ~/.config/colorschemes/dmenu/current.c
cd ~/.config/dmenu/
sudo make clean install
#dunst
cp ~/.config/colorschemes/dunst/$scheme ~/.config/dunst/dunstrc
killall dunst
setsid dunst &
