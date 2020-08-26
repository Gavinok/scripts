#!/bin/sh

scheme=$(cat ~/.config/colorschemes/current)
if [ "$scheme" = "dark" ];then
	scheme="light"
else
	scheme="dark"
fi

command -v "xgetres" >/dev/null || { notify-send "📦 xgetres must be installed for this function." && exit 1; } 

#Xresources
cp ~/.config/colorschemes/xresources/$scheme ~/.config/colorschemes/xresources/current
xrdb ~/.Xresources

export BACKGROUND=$(xgetres '*.background')
export FOREGROUND=$(xgetres '*.foreground')
export BANNER=$(xgetres '*.banner')
export ALT=$(xgetres '*.alt')

# envsubst settings
export FONT='monospace'
export FONTSIZE='10'

#dunst
envsubst < ~/.config/colorschemes/dunst/dunstrc.template > ~/.config/dunst/dunstrc
killall dunst
setsid dunst &

#jgmenu
envsubst < ~/.config/colorschemes/jgmenu/jgmenurc.template > ~/.config/jgmenu/jgmenurc

#Xresources
cp ~/.config/colorschemes/xresources/$scheme ~/.config/colorschemes/xresources/current
xrdb ~/.Xresources

#wall
cp ~/.config/colorschemes/wall/$scheme.png ~/.config/wall.png
setbg

#vifm
cp ~/.config/colorschemes/vifm/$scheme.vifm ~/.config/vifm/colors/current.vifm

#vim and bash and newsboat
if [ $scheme = "dark" ]; then
	#vimrc
	sed -i 's/acme/spaceway/g' ~/.vimrc
	#bashrc
	sed -i "s/TEXTCOLOR=30m/TEXTCOLOR=37m/g" ~/.bashrc 
	sed -i "s/PATHCOLOR=30m/PATHCOLOR=34m/g" ~/.bashrc 
	sed -i "s/PROMPTCOLOR=30m/PROMPTCOLOR=35m/g" ~/.bashrc 
	sed -i "s/SCHEME=light/SCHEME=dark/g" ~/.bashrc 
	#zsh
	sed -i 's/#PROMPT/PROMPT/g' ~/.zshrc
	sed -i 's/PROMPT.*#light/#\0/g' ~/.zshrc
	sed -i "s/SCHEME=light/SCHEME=dark/g" ~/.zshrc
	#newsboat
	sed -i "s/black/color15/g" ~/.config/newsboat/config
	sed -i "s/color info black default bold/color info red default bold/g" ~/.config/newsboat/config
	sed -i "s/color listnormal_unread blue default bold/color listnormal_unread white default bold/g" ~/.config/newsboat/config
	#ranger
	sed -i "s/bwlight/solarized/g" ~/.config/ranger/rc.conf
	#rtv
	sed -i "s/mytheme2/mytheme1/g" ~/.config/rtv/rtv.cfg
	#compton
	setsid picom &
	setsid flashfocus &
	#mutt
	sed -i "s\source ~/.config/colorschemes/mutt/light\\g" ~/.config/mutt/muttrc

else
	#vimrc
	sed -i 's/spaceway/acme/g' ~/.vimrc
	#bashrc
	sed -i "s/TEXTCOLOR=37m/TEXTCOLOR=30m/g" ~/.bashrc 
	sed -i "s/PATHCOLOR=34m/PATHCOLOR=30m/g" ~/.bashrc 
	sed -i "s/PROMPTCOLOR=35m/PROMPTCOLOR=30m/g" ~/.bashrc 
	sed -i "s/SCHEME=dark/SCHEME=light/g" ~/.bashrc 
	#zsh
	sed -i 's/#PROMPT/PROMPT/g' ~/.zshrc
	sed -i 's/PROMPT.*#dark/#\0/g' ~/.zshrc
	sed -i "s/SCHEME=light/SCHEME=dark/g" ~/.zshrc
	#newsboat
	sed -i "s/color15/black/g" ~/.config/newsboat/config
	sed -i "s/white/black/g" ~/.config/newsboat/config
	sed -i "s/color info red default bold/color info black default bold/g" ~/.config/newsboat/config
	sed -i "s/color listnormal_unread black default bold/color listnormal_unread black default bold/g" ~/.config/newsboat/config

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
# cp ~/.config/colorschemes/dwm/$scheme.h ~/.config/colorschemes/dwm/current.h
# cd ~/.config/dwm/ || exit
# sudo make clean install
# killall dwm

#dmenu
if [ -f "~/.config/colorschemes/dmenu/$scheme.h" ] ; then
	cp ~/.config/colorschemes/dmenu/$scheme.h ~/.config/colorschemes/dmenu/current.h
	cd ~/.config/dmenu/ || exit
	sudo make clean install
fi

#surf
# cp ~/.config/colorschemes/surf/$scheme.h ~/.config/colorschemes/surf/current.h
# cd ~/.config/surf/ || exit
# sudo make clean install

#update scheme
echo $scheme > ~/.config/colorschemes/current
notify-send "Scheme set to $scheme"
