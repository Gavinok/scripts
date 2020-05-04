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

# check if wifi is connected
if ! ip link show "${DEVICE}" | grep 'UP'; then 
  # turn connection on
  sudo ip link set "${DEVICE}" up || notify "set ${DEVICE} to UP"
fi

# check if already connected
if iw "${DEVICE}" link | Grep 'Connected to .*'; then 
  notify "wifi is already connected" 
  exit
fi

# get the avalilable networks 
sudo iw wls1 scan |awk '/SSID: [^[:space:]]+.*/ {print $2}'

# TODO: select a network 
# WIFI=

# Connect to WPA/WPA2 WiFi network
# XXX: not sure if this works
wpa_passphrase "${WIFI}" |sudo tee -a /etc/wpa_supplicant.conf 

# -B means run wpa_supplicant in the background.
# -D specifies the wireless driver. wext is the generic driver.
#    nl80211 is the current standard, but not all wireless 
#    chip's modules support it
# -c specifies the path for the configuration file.
sudo wpa_supplicant -B -D wext -i "${DEVICE}" -c /etc/wpa_supplicant.conf

iw "${DEVICE}" link

sudo dhclient "${DEVICE}"

IPADDR=$(ip addr show wls1 | awk '/inet.*wls1/ {print $2}')

# TODO: add routing 
# sudo ip route add default via 192.168.0.255 dev wls1

# check that default has been set
ip route show | grep 'default' 
# vim: set tw=78 ts=2 et sw=2 sr:
