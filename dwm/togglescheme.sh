#!/usr/bin/dash

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

#ranger
cp ~/.config/colorschemes/wall/$scheme.png ~/.config/wall.png
setbg

#vim and bash and newsboat
if [ $scheme = "dark" ]; then
    #vimrc
    sed -i 's/acme/spacegray/g' ~/.vimrc
    #bashrc
    sed -i "s/TEXTCOLOR=30m/TEXTCOLOR=37m/g" ~/.bashrc 
    sed -i "s/PATHCOLOR=30m/PATHCOLOR=34m/g" ~/.bashrc 
    sed -i "s/PROMPTCOLOR=30m/PROMPTCOLOR=35m/g" ~/.bashrc 
    sed -i "s/SCHEME=light/SCHEME=dark/g" ~/.bashrc 
    #newsboat
    sed -i "s/black/blue/g" ~/.config/newsboat/config
    sed -i "s/color info black default bold/color info red default bold/g" ~/.config/newsboat/config
    sed -i "s/color listnormal_unread yellow default bold/color listnormal_unread blue default bold/g" ~/.config/newsboat/config
    #ranger
    sed -i "s/bwlight/solarized/g" ~/.config/ranger/rc.conf
    #rtv
    sed -i "s/mytheme2/mytheme1/g" ~/.config/rtv/rtv.cfg
    #compton
    setsid compton &
    setsid flashfocus &
    #mutt
    sed -i "s\source ~/.config/colorschemes/mutt/light\\g" ~/.config/mutt/muttrc

else
    #vimrc
    sed -i 's/spacegray/acme/g' ~/.vimrc
    #bashrc
    sed -i "s/TEXTCOLOR=37m/TEXTCOLOR=30m/g" ~/.bashrc 
    sed -i "s/PATHCOLOR=34m/PATHCOLOR=30m/g" ~/.bashrc 
    sed -i "s/PROMPTCOLOR=35m/PROMPTCOLOR=30m/g" ~/.bashrc 
    sed -i "s/SCHEME=dark/SCHEME=light/g" ~/.bashrc 
    #newsboat
    sed -i "s/blue/black/g" ~/.config/newsboat/config
    sed -i "s/color info red default bold/color info black default bold/g" ~/.config/newsboat/config
    sed -i "s/color listnormal_unread blue default bold/color listnormal_unread yellow default bold/g" ~/.config/newsboat/config
    #ranger
    sed -i "s/solarized/bwlight/g" ~/.config/ranger/rc.conf
    #rtv
    sed -i "s/mytheme1/mytheme2/g" ~/.config/rtv/rtv.cfg
    #ducksearch
    sed -i "s/kae=d/kae=-1/g" ~/.scripts/dmenu/ducksearch
    #compton
    killall compton
    killall flashfocus
    #mutt
    echo 'source ~/.config/colorschemes/mutt/light' ~/.config/mutt/muttrc
fi

#dwm
cp ~/.config/colorschemes/dwm/$scheme.h ~/.config/colorschemes/dwm/current.h
cd ~/.config/dwm/ || exit
sudo make clean install
killall dwm

#dmenu
cp ~/.config/colorschemes/dmenu/$scheme.h ~/.config/colorschemes/dmenu/current.h
cd ~/.config/dmenu/ || exit
sudo make clean install

#dwm
cp ~/.config/colorschemes/surf/$scheme.h ~/.config/colorschemes/surf/current.h
cd ~/.config/surf/ || exit
sudo make clean install

#update scheme
echo $scheme > ~/.config/colorschemes/current
notify-send "Scheme set to $scheme"
