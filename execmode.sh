dmenu_path | grep dmenu | sed '/dmenu_run/d' | sed '/dmenu_recency/d'| sed '/dmenu_recent/d' | sed '/dmenu_path/d'| sed '/i3/d' | sed '/^dmenuumount$/d' | sed '/^dmenumount$/d' |sed '/^dmenurecord$/d' |  sed "/^dmenu$/d"|   dmenu -p ':' | ${SHELL:-"/bin/sh"} &

