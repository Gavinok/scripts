#!/usr/bin/env bash

scheme=$(cat ~/.config/colorschemes/current)
if [ "$scheme" = "dark" ];then
    scheme="light"
else
    scheme="dark"
fi

#Xresources
cp ~/.config/colorschemes/xresources/$scheme ~/.config/colorschemes/xresources/current
xrdb ~/.Xresources

#dunst
cp ~/.config/colorschemes/dunst/$scheme ~/.config/dunst/dunstrc
killall dunst
setsid dunst &

#wall
cp ~/.config/colorschemes/wall/$scheme.png ~/.config/wall.png
setbg

#vim and bash and newsboat
if [ $scheme = "dark" ]; then
    sed -i 's/acme/spacegray/g' ~/.vimrc
    sed -i "s/TEXTCOLOR=30m/TEXTCOLOR=37m/g" ~/.bashrc 
    sed -i "s/SCHEME=light/SCHEME=dark/g" ~/.bashrc 
    sed -i "s/black/blue/g" ~/.config/newsboat/config
else
    sed -i 's/spacegray/acme/g' ~/.vimrc
    sed -i "s/TEXTCOLOR=37m/TEXTCOLOR=30m/g" ~/.bashrc 
    sed -i "s/SCHEME=dark/SCHEME=light/g" ~/.bashrc 
    sed -i "s/blue/black/g" ~/.config/newsboat/config
fi

#dwm
cp ~/.config/colorschemes/dwm/$scheme.c ~/.config/colorschemes/dwm/current.c
cd ~/.config/dwm/ || exit
sudo make clean install
killall dwm

#dmenu
cp ~/.config/colorschemes/dmenu/$scheme.c ~/.config/colorschemes/dmenu/current.c
cd ~/.config/dmenu/ || exit
sudo make clean install

#update scheme
echo $scheme > ~/.config/colorschemes/current
notify-send "scheme set to $scheme"
