#!/usr/bin/dash

echo 'auto' | sudo tee '/sys/bus/usb/devices/4-1/power/control'

wifiman(){
    if ping -q -c 1 8.8.8.8; then
    	dropbox-cli start
	WIFI=$(printf "%s " "$wifiicon" && nmcli connection show --active | sed '1d'  | awk '{print $1}')
	[ $WIFI != 'Uvic' ] &&
	case $WIFI in
		Uvic )
			killall kdeconnectd ;;
		ShawOpen )
			killall kdeconnectd ;;
		*)
    	kdeconnect-cli -l

	esac
    else
    	killall dropbox
    	# killall kdeconnectd
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

spcpugov(){
    full=$(cat /sys/class/power_supply/BAT1/energy_full)
    now=$(cat /sys/class/power_supply/BAT1/energy_now)
    state=$(cat /sys/class/power_supply/BAT1/status)
    [ "$state" = Charging ] && echo 100 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct && exit
    batt=$(echo "scale=2; 100*($now/$full)" | bc | cut -d"." -f1)
    [ "$batt" -ge "80" ] && echo 80 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct && exit
    [ "$batt" -ge "35" ] && echo 50 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct && exit
    echo 26 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct && exit
}

device=$(uname -n)
wifiman
[ "$device" = "sp4" ] && spcpugov && exit
cpugov
