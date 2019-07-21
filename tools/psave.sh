#!/usr/bin/dash

echo 'auto' > '/sys/bus/usb/devices/4-1/power/control'

wifiman(){
    if ping -q -c 1 8.8.8.8; then
    	dropbox-cli start
    	kdeconnect-cli -l
    else
    	echo bye
    	killall dropbox
    	killall kdeconnectd
    fi
}
cpugov(){
    full=$(cat /sys/class/power_supply/BAT0/energy_full)
    now=$(cat /sys/class/power_supply/BAT0/energy_now)
    state=$(cat /sys/class/power_supply/BAT0/status)
    [ "$state" = Charging ] && echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && exit

    batt=$(echo "scale=2; 100*($now/$full)" | bc | cut -d"." -f1)
    if [ "$batt" -ge "50" ] ;then
	echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && exit
    fi
    echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
}

wifiman
cpugov
