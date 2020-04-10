#!/usr/bin/dash

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : psave.sh
# @created     : Thu 05 Dec 2019 01:03:47 PM MST
#
# @description : This is a simple script used for managing power.
#                Simply set this as a cronjob (i have it run every 15
#                minutes).  This script is specific to my thinkpad x200, I
#                tried to remove some of the stuff specific to me and left a
#                label where it used to be.
#
# @resources   : If you want to learn more about how this script works and
#                other optimizations checkout these resources.
#                https://wiki.archlinux.org/index.php/CPU_frequency_scaling
#                https://wiki.archlinux.org/index.php/Power_management
#
# @WARNING     : This script may conflict with other power managers on your
#                system such as tlp. This Script is very specific to my
#                machine so you will probably have to make some adjustments.
######################################################################

# manage power to usb ports

wifiman(){
  # Check for wifi and determines if it should start syncthing
  if ping -q -c 1 8.8.8.8; then
    syncthing -no-browser 2>&1 >/dev/null | xargs notify-send
    WIFI=$(nmcli connection show --active | sed '1d'  | awk '{print $1}')

    # Only kill kdeconnect when using wifi that doesn't support it
    case ${WIFI} in
      Uvic )
        killall kdeconnectd ;;
      ShawOpen )
        killall kdeconnectd ;;
      *)
        # If on any other wifi start kdeconnect
        # Since kdeconnect isnt working comment it out
        # kdeconnect-cli -l;;
    esac
  else
    # If there is no wifi kill syncthing and kdeconnect 
    killall syncthing
    # killall kdeconnectd
  fi
}

# This adjusts the maximum clock of the cpu depending on the current battery
# percentage as well as if it is charging. If you have a more modern CPU I
# highly recommend you use spcpugov instead. the numbers used for
# scaling_max_freq should be adjusted based on the options available for your
# computer. to find these stats use check the
# /sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies.
# double check that the BAT# is correct for your computer
cpugov(){
  full=$(cat /sys/class/power_supply/BAT0/energy_full)
  now=$(cat /sys/class/power_supply/BAT0/energy_now)
  state=$(cat /sys/class/power_supply/BAT0/status)
  [ "${state}" = Charging ] && echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && \
    echo 1867000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq && exit
      batt=$(echo "scale=2; 100*(${now}/${full})" | bc | cut -d"." -f1)
      [ "${batt}" -ge "80" ] && echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && \
        echo 1867000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq && exit
              [ "${batt}" -ge "35" ] && echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && \
                echo 1600000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq && exit
                              echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor && \
                                echo 1867000 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq && exit
                              }

# This version of cpugov is works on more modern computers since intel_pstate
# is more efficient then cpufreq but is only available in 'core i' series cpus
# double check that the BAT# is correct for your computer
spcpugov(){
  full=$(cat /sys/class/power_supply/BAT1/energy_full)
  now=$(cat /sys/class/power_supply/BAT1/energy_now)
  state=$(cat /sys/class/power_supply/BAT1/status)
  [ "${state}" = Charging ] && echo 100 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct && exit
  batt=$(echo "scale=2; 100*(${now}/${full})" | bc | cut -d"." -f1)
  [ "${batt}" -ge "80" ] && echo 80 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct && exit
  [ "${batt}" -ge "35" ] && echo 50 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct && exit
  echo 26 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct && exit
}

# device=$(uname -n)
wifiman "$1"
# replace MODERN with the name of the system that should use spcpugov
# [ "$device" = "MODERN" ] && spcpugov && exit
# cpugov

# vim: set tw=78 ts=2 et sw=2 sr:
