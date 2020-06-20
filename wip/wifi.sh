#!/usr/bin/env sh

######################################################################
# @author      : Gavin Jaeger-Freeborn (gavinfreeborn@gmail.com)
# @file        : wifi.sh
# @created     : Tue 14 Apr 2020 12:45:32 PM
#
# @description : script to connect to wifi
######################################################################

# TODO: setup wpa_cli events fo connected and disconnected
# https://wiki.archlinux.org/index.php/Wpa_supplicant#wpa_cli_action_script

#get the name of the wifi device
DEVICE=$(iw dev | awk '/Interface/ {print $2}')

if [ $(echo $DEVICE | wc -l) -gt 1 ]; then
  DEVICE=$(echo $DEVICE | dmenu -p 'select device')
fi

# check if wifi is connected
echo "check if device is enabled"
if ! ip link show "${device}" | grep 'up'  ; then 
  echo "device is not enabled"
  # turn connection on
  sudo ip link set "${DEVICE}" up || notify "set ${DEVICE} to UP"
fi

# check if already connected
echo "check if already connected"
if iw "${DEVICE}" link | grep 'Connected to .*' ; then 
  notify-send "wifi is already connected" 
  exit
fi

# get the avalilable networks 
echo "get the avalilable networks"
WIFI=$(sudo iw wls1 scan |awk '/ssid: [^[:space:]]+.*/ {print $2}' | dmenu -p "Select Network")

# TODO: select a network 
# WIFI=

# Connect to WPA/WPA2 WiFi network
# XXX: not sure if this works
echo "add passphrase to wpa_supplicant"
wpa_passphrase "${WIFI}" |sudo tee -a /etc/wpa_supplicant.conf 

# -B means run wpa_supplicant in the background.
# -D specifies the wireless driver. wext is the generic driver.
#    nl80211 is the current standard, but not all wireless 
#    chip's modules support it
# -c specifies the path for the configuration file.
sudo wpa_supplicant -B -D wext -i "${DEVICE}" -c /etc/wpa_supplicant.conf

iw "${DEVICE}" link

# use dhclient to get ip address
sudo dhclient "${DEVICE}"

IPADDR=$(ip addr show wls1 | awk '/inet.*wls1/ {print $2}')

# TODO: add routing 
# sudo ip route add default via 192.168.0.255 dev wls1

# check that default has been set
ip route show | grep 'default' 
# vim: set tw=78 ts=2 et sw=2 sr:
