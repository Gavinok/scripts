#!/bin/sh
# utilises dunstify ant amixer to notify the 
# user of the volume as well as chang it
# Get the index of the selected sink:
getsink() {
    pacmd list-sinks | awk '/index:/{i++} /* index:/{print i; exit}'
}
# Get the selected sink volume
getvolume() {
    volume="$(pactl list sinks | grep 'Mute: yes')"
    [ -n "$volume" ] &&  /usr/bin/dunstify -r 798 -t 500 "🔈 MUTE" && exit

    volume=$(pacmd list-sinks | awk '/^\svolume:/{i++} i=='"$(getsink)"'{print $5; exit}')
    /usr/bin/dunstify -r 798 -t 500 "Volume: ${volume}"
}
getvolume
