#!/bin/bash
# Screenshot: http://s.natalian.org/2013-08-17/dwm_status.png
# Network speed stuff stolen from http://linuxclues.blogspot.sg/2009/11/shell-script-show-network-speed.html

# This function parses /proc/net/dev file searching for a line containing $interface data.
# Within that line, the first and ninth numbers after ':' are respectively the received and transmited bytes.
function get_bytes {
# Find active network interface
interface=$(ip route get 8.8.8.8 2>/dev/null| awk '{print $5}')
line=$(grep $interface /proc/net/dev | cut -d ':' -f 2 | awk '{print "received_bytes="$1, "transmitted_bytes="$9}')
eval $line
now=$(date)
}

# Function which calculates the speed using actual and old byte number.
# Speed is shown in KByte per second when greater or equal than 1 KByte per second.
# This function should be called each second.

function get_velocity {
value=$1
old_value=$2
now=$3

timediff=$(($now - $old_time))
velKB=$(echo "1000000000*($value-$old_value)/1024/$timediff" | bc)
if test "$velKB" -gt 1024
then
	echo $(echo "scale=2; $velKB/1024" | bc)MB/s
else
	echo ${velKB}KB/s
fi
}

# Get initial values
get_bytes
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes
old_time=$now

print_volume() {
	volume="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
	if test "$volume" -gt 0
	then
		echo -e "${volume}% VOL"
	else
		echo -e "Mute VOL"
	fi
}

print_wifi() {
	ip=$(ip route get 8.8.8.8 2>/dev/null|grep -Eo 'src [0-9.]+'|grep -Eo '[0-9.]+')

	if=wlan0
		while IFS=$': \t' read -r label value
		do
			case $label in SSID) SSID=$value
				;;
			signal) SIGNAL=$value
				;;
		esac
	done < <(iw "$if" link)

	echo -e "$SSID $SIGNAL $ip WIFI"
}

print_mem(){
	memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))

	# memorfree -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }'
	echo -e "$memfree MEM"
}

print_temp(){
	test -f /sys/class/thermal/thermal_zone0/temp || return 0
	echo $(head -c 2 /sys/class/thermal/thermal_zone0/temp)C
}

print_bat(){
	hash acpi || return 0
	onl="$(grep "on-line" <(acpi -V))"
	charge="$(awk '{ sum += $1 } END { print sum }' /sys/class/power_supply/BAT*/capacity)"
	if test -z "$onl"
	then
		# suspend when we close the lid
		#systemctl --user stop inhibit-lid-sleep-on-battery.service
		echo -e "${charge}% BAT"
	else
		# On mains! no need to suspend
		#systemctl --user start inhibit-lid-sleep-on-battery.service
		echo -e " ${charge}% BAT"
	fi
}

print_date(){
	date '+%a, %b %d, %Y at %I:%M %p'

}

show_record(){
	test -f /tmp/r2d2 || return
	rp=$(cat /tmp/r2d2 | awk '{print $2}')
	size=$(du -h $rp | awk '{print $1}')
	echo " $size $(basename $rp)"
}

while true
do

	# Get new transmitted, received byte number values and current time
	# get_bytes

	# # Calculates speeds
	# vel_recv=$(get_velocity $received_bytes $old_received_bytes $now)
	# vel_trans=$(get_velocity $transmitted_bytes $old_transmitted_bytes $now)

	# xsetroot -name "$(print_mem) $(print_temp)  $(print_bat) $(show_record) $(print_date)"
	xsetroot -name "[$(print_volume)] [$(print_temp)] [$(print_mem)] [$(print_bat)] [$(print_date)]"


	# Update old values to perform new calculations
	# old_received_bytes=$received_bytes
	# old_transmitted_bytes=$transmitted_bytes
	# old_time=$now

	sleep 1

done
