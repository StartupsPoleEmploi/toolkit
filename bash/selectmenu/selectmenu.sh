selectmenu() {
	local POS=0;
	local RET=0;
	for var in $@; do
		if [[ "$var" =~  ^-s([0-9]+)$ ]]; then POS=$[${BASH_REMATCH[1]}-1]; shift; fi
		if [[ "$var" =~  ^-ro$ ]]; then RET=1; shift; fi
	done
	local NB_ITEMS=$#;

	while true;
	do
		local i=0;
		for item in $@;
		do
			local STYLE="\x1b[0m";
			if [ $((i++)) -eq $POS ]; then STYLE="\e[7m"; fi
			echo -en "$STYLE${item}\x1b[0m\n";
		done
		read -rsn1 key;
		case "$key" in
			$'\x1b') # Arrow hors escape
				read -rsn2 -t0.1 key;
				if [ "$key" = $'[A' ] && [ $POS -ne 0 ]; then POS=$[$POS-1]; fi
				if [ "$key" = $'[B' ] && [ $POS -lt $[$NB_ITEMS-1] ]; then POS=$[$POS+1]; fi
				if [ "$key" = "" ]; then return 1; fi
				;;
			"") # Enter
				if [ $POS -ge 0 ]; then ((POS++)); break; fi
				;;
		esac
		echo -e "\033["$[$NB_ITEMS+1]"A";
	done
	[[ $RET -eq 0 ]] && echo ${!POS} || echo $POS;
}

