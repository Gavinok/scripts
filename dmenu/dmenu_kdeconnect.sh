#!/usr/bin/env sh
# dmenu_kdeconnect.sh is a script based off of these scripts
# [polybar-kdeconnect] https://github.com/HackeSta/polybar-kdeconnect 
# [polybar-kdeconnect-scripts] https://github.com/witty91/polybar-kdeconnect-scripts
# Added features
# - Removed polybar as a Dependencies (since I use dwm)
# - Integration with a variety of file managers
# - Implementation as one simplified shell script
# - utilize sh instead of bash

#TODO
	# 1. Allow different dmenu colors based on the battery percentage
	# 2. Make the script no sh complaint
	# 3. Implement a contacts list to make sms messaging easier

# Dependancies
	# -dmenu
	# -kdeconnect
	# -zenity, nnn, or ranger
	# -qt5tools
	# -dbus
	# -dunst

# options
# nnn
# zenity
# ranger
Picker='nnn'

# Color Settings of dmenu 
COLOR_DISCONNECTED='#000'       # Device Disconnected
COLOR_NEWDEVICE='#ff0'          # New Device
COLOR_BATTERY_90='#fff'         # Battery >= 90
COLOR_BATTERY_80='#ccc'         # Battery >= 80
COLOR_BATTERY_70='#aaa'         # Battery >= 70
COLOR_BATTERY_60='#888'         # Battery >= 60
COLOR_BATTERY_50='#666'         # Battery >= 50
COLOR_BATTERY_LOW='#f00'        # Battery <  50

# Icons shown in dmenu
ICON_SMARTPHONE=''
ICON_TABLET=''
SEPERATOR='|'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

show_devices (){
    IFS=$','
    devices=""
	# for all the devices avalable
    for device in $(qdbus --literal org.kde.kdeconnect /modules/kdeconnect org.kde.kdeconnect.daemon.devices); do
		#get the device info
        deviceid=$(echo "$device" | awk -F'["|"]' '{print $2}')
        devicename=$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$deviceid org.kde.kdeconnect.device.name)
        devicetype=$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$deviceid org.kde.kdeconnect.device.type)
        isreach="$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$deviceid org.kde.kdeconnect.device.isReachable)"
        istrust="$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$deviceid org.kde.kdeconnect.device.isTrusted)"
        if [ "$isreach" = "true" ] && [ "$istrust" = "true" ];then
			#is connected
            battery="$(qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$deviceid org.kde.kdeconnect.device.battery.charge)%"
            icon=$(get_icon $battery $devicetype)
			# colors="$(get_colors $battery)"
			# echo "$colors"
			show_menu "$devicename | $battery $icon" $deviceid $battery 
            devices+="$devicename $battery $icon $SEPERATOR"
        elif [ "$isreach" = "false" ] && [ "$istrust" = "true" ];then
			#nothing is found
            devices+="$(get_icon -1 $devicetype)$SEPERATOR"
        else 
			#found but not yet paired
            icon=$(get_icon -2 $devicetype)
			show_pmenu $devicename $deviceid
            devices+="$devicename $icon $SEPERATOR"

        fi
    done
}

#used to interact with notifications if they are avalable
Notification_menu () {
	replyable=`qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2/notifications/$1 org.kde.kdeconnect.device.notifications.notification.replyId`
	echo $replyable
	options=$(printf "View\\nDissmiss")
	if [ "$replyable" ]; then 
		options+=$(printf "\\nReply")
		optionNum=$((optionNum+1))
	fi
	ticker1=`qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2/notifications/$1 org.kde.kdeconnect.device.notifications.notification.ticker`
        prompt=$(echo $ticker1 | cut -c 1-100)
    menu=$(echo $options | dmenu -i -p "$prompt" -l $optionNum )
	case "$menu" in
		*'View' ) 
			ticker1=`qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2/notifications/$1 org.kde.kdeconnect.device.notifications.notification.ticker`
			notify-send "$ticker1";;
		*'Dissmiss')
			qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2/notifications/$1 org.kde.kdeconnect.device.notifications.notification.dismiss;;
		*'Reply' ) 
				qdbus org.kde.kdeconnect /modules/kdeconnect/devices/$2/notifications/$1 org.kde.kdeconnect.device.notifications.notification.reply;;
	esac
}

#displays a menu for the connected device
show_menu () {
	optionNum=5
	options=$(printf "Send SMS\\nSend File\\nFind Device\\nPing\\nUnpair\\n")
	notification1=`dbus-send --session --print-reply --dest="org.kde.kdeconnect" /modules/kdeconnect/devices/$2 org.kde.kdeconnect.device.notifications.activeNotifications|tr '\n' ' ' | awk '{print $12}'| sed s/\"//g`
	if [ $notification1 ]; then
		options+=$(printf "\\nNotification")
		optionNum=$((optionNum+1))
	fi
	options+=$(printf "\\nRefresh\\n")
    menu=$(echo $options | dmenu -i -p $1 -l $optionNum )
                case "$menu" in
                    *'Ping') 
						message=$(echo 'Ping' | dmenu -i -p "Msg to send")
						kdeconnect-cli --ping-msg "$message" -d $2;;
                    *'Find Device') kdeconnect-cli --ring -d $2 ;;
                    *'Send File') 
						[ $Picker == 'nnn' ] && kdeconnect-cli --share "file://$($TERMINAL nnn -p -)" -d $2 ;
						[ $Picker == 'zenity' ] && kdeconnect-cli --share "file://$(zenity --file-selection)" -d $2 ;
						if [ $Picker == 'ranger' ]; then
 							mkdir -p /tmp/ranger/ && touch /tmp/ranger/sentfile
							kdeconnect-cli --share "file://$($TERMINAL ranger --choosefile=/tmp/ranger/sentfile)" -d $2 
						fi;;
                    *'Unpair' ) kdeconnect-cli --unpair -d $2 ;;
                    *'Send SMS' ) 
						message=$(echo 'OTW' | dmenu -i -p "Msg to send")
						recipient=$(echo '14039199518' | dmenu -i -p "Recipient's phone #")
						kdeconnect-cli --send-sms "$message" --destination "$recipient" -d $2 ;;
                    *'Refresh' ) 
						kdeconnect-cli --refresh;;
                    *'Notification' ) 
						Notification_menu $notification1 $2;;
                esac
}

show_pmenu () {
    menu="$(printf "Pair Device" | dmenu -i -p "$1"  )"
                case "$menu" in
                    *'Pair Device') kdeconnect-cli --pair -d $2 ;;
                esac
}
#still a work in progress
get_colors () {
	case $1 in
	"-1")     colors="-nb \"$COLOR_DISCONNECTED\" -nf \"#000\" " ;;   
	"-2")     colors="-nb \"$COLOR_NEWDEVICE\"	-nf \"#000\" ";;   
	5*)     	colors="-nb \"$COLOR_BATTERY_50\"	-nf \"#000\" ";;
	6*)		colors="-nb \"$COLOR_BATTERY_60\"	-nf \"#000\" ";;
	7*)    	colors="-nb \"$COLOR_BATTERY_70\"	-nf \"#000\" ";;
	8*)     	colors="-nb \"$COLOR_BATTERY_80\"	-nf \"#000\" ";;
	*)      	colors="-nb \"$COLOR_BATTERY_LOW\" -nf \"#000\" ";; 
	9*|100) 	colors="-nb \"$COLOR_BATTERY_90\"	-nf \"#000\" ";;
	esac
	echo $colors
}

get_icon () {
    if [ "$2" = "tablet" ]
    then
        ICON=$ICON_TABLET
    else
        ICON=$ICON_SMARTPHONE
    fi
    echo $ICON
}
show_devices
