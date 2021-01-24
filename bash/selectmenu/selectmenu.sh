selectmenu() {
	local POS=0;
	local RET=0;
	local MAX_LEN=0;
	local MULTI=0;
	local ALIGN=-1;
	for var in $@; do
		if [[ "$var" =~  ^-s([0-9]+)$ ]]; then POS=$[${BASH_REMATCH[1]}-1]; shift; fi
		if [[ "$var" =~  ^-ro$ ]]; then RET=1; shift; fi
		if [[ "$var" =~  ^-a([0-9]+)$ ]]; then ALIGN=$[${BASH_REMATCH[1]}]; shift; fi
		if [[ "$var" =~  ^-m$ ]]; then MULTI=1; shift; fi
		if [[ "$var" =~  ^[^-].*$ ]]; then [[ ${#var} -ge $MAX_LEN ]] && MAX_LEN=${#var}; fi
	done
	local SELECT=();
	local NB_ITEMS=$#;
	local IFS=;
	local i;
	local args=($@);
	[[ $ALIGN -lt 0 ]] && ALIGN=$MAX_LEN;

	while true;
	do
		i=0;
		for item in ${args[@]};
		do
			local STYLE="\x1b[0m";

			[[ "${SELECT[$i]}" != "" && $i -ne $POS ]] && STYLE="\e[100m";
			if [ $i -eq $POS ]; then [ "${SELECT[$i]}" != "" ] && STYLE="\e[41m" || STYLE="\e[7m"; fi
			((i++));
			printf "$STYLE%-${ALIGN}s\x1b[0m\n" $item;
		done
		read -rsn1 key;
		case "$key" in
			$'\x1b') # Arrow except escape
				read -rsn2 -t0.1 key;
				[ "$key" = $'[A' ] && ((POS--));
				[ "$key" = $'[B' ] && ((POS++));
				[ "$key" = "" ] && return 1;
				;;
			" ") # Space
				if [ $MULTI -eq 1 ];
				then
					[[ "${SELECT[$POS]}" != "" ]] && SELECT[$POS]="" || SELECT[$POS]=`[ $RET -eq 1 ] && echo "$POS" || echo "${args[$POS]}"`;
					((POS++));
				fi
				;;
			"") # Enter
				if [ $POS -ge 0 ]; then ((POS++)); break; fi
				;;
		esac
		[ $POS -lt 0 ] && POS=0;
		[ $POS -gt $[$NB_ITEMS-1] ] && POS=$[$NB_ITEMS-1];

		echo -e "\033["$[$NB_ITEMS+1]"A";
	done

	if [ $MULTI -eq 1 ];
	then
		REPLY=(${SELECT[@]});
		#for i in ${SELECT[@]}; do echo $i; done
	else
		REPLY=`[[ $RET -eq 0 ]] && echo ${!POS} || echo $POS`;
	fi
	return 0;
}

