#!/usr/bin/dash

echo 'auto' | sudo tee '/sys/bus/usb/devices/4-1/power/control'

wifiman(){
    if ping -q -c 1 8.8.8.8; then
    	dropbox-cli start
    	kdeconnect-cli -l
    else
    # if [ "$batt" -le "50" ] ;then
	# sudo systemctl stop NetworkManager.service
    # else
	# sudo systemctl start NetworkManager.service
    # fi
    	echo bye
    	killall dropbox
    	killall kdeconnectd
    fi
}

cpugov(){
    full=$(cat /sys/class/power_supply/BAT0/energy_full)
    now=$(cat /sys/class/power_supply/BAT0/energy_now)
    state=$(cat /sys/class/power_supply/BAT0/status)
    [ "$state" = Charging ] && echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo 1867000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq && exit

    batt=$(echo "scale=2; 100*($now/$full)" | bc | cut -d"." -f1)
    [ "$batt" -ge "80" ] && echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo 1867000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq && exit
    [ "$batt" -ge "35" ] && echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo 1600000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq && exit
    echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && echo 1867000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq && exit
}

wifiman
cpugov
