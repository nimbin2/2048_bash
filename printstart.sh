#!/bin/bash
## startgame.sh

printStart() {
	blackScreen

	centerS=$[MW/2-29]
	printf "\e[37;40m\e[1;$[centerS]f█████████████████████████████████████▀█████████████████████"
	printf "\e[2;$[centerS]f█ ▄▄▄▄█ ▄ ▄ ██▀▄ ██▄ ▄▄▀█ ▄ ▄ ███ ▄▄▄▄██▀▄ ██▄ ▀█▀ ▄█▄ ▄▄ █"
	printf "\e[3;$[centerS]f█▄▄▄▄ ███ ████ ▀ ███ ▄ ▄███ █████ ██▄ ██ ▀ ███ █▄█ ███ ▄█▀█"
	printf "\e[4;$[centerS]f█▄▄▄▄▄██▄▄▄██▄▄█▄▄█▄▄█▄▄██▄▄▄████▄▄▄▄▄█▄▄█▄▄█▄▄▄█▄▄▄█▄▄▄▄▄█\e[0m"

	startLabel="   Start by pressing Enter   "
	startAutoLabel="   Autorun by pressing a   "
	startPrevLabel="   Load last game by pressing s   "
	fillL=$(seq -s' ' $[${#startPrevLabel}+1]|tr -d '[:digit:]')
	messageAuto="   Enter delay in 0.X seconds"
	printf "\e[1;47;30m\e[$[MH/2];$[MW/2-${#startPrevLabel}/2]f$fillL"
	printf "\e[$[MH/2+1];$[MW/2-${#startPrevLabel}/2]f$fillL"
	printf "\e[$[MH/2+1];$[MW/2-${#startPrevLabel}/2]f$startLabel"
	printf "\e[$[MH/2+2];$[MW/2-${#startPrevLabel}/2]f$fillL"
	printf "\e[$[MH/2+3];$[MW/2-${#startPrevLabel}/2]f$fillL\e"
	printf "\e[$[MH/2+3];$[MW/2-${#startPrevLabel}/2]f$startAutoLabel"
	printf "\e[$[MH/2+4];$[MW/2-${#startPrevLabel}/2]f$fillL\e"
	printf "\e[$[MH/2+5];$[MW/2-${#startPrevLabel}/2]f$startPrevLabel"
	printf "\e[$[MH/2+6];$[MW/2-${#startPrevLabel}/2]f$fillL\e[0m"

	keyS="0"
	loadSaved=false

	printf "\e[$[MH/2+7];$[MW/2]f"
	while true; do

		read -rsn1 keyS
# normal game
		if [ -z $keyS ]; then
			echo "##$keyS++"
			autorun=false
			break
# auto game
		elif [[ "$keyS" == "a" ]]; then
			autorun=true
			printf "\e[1;47;30m\e[$[MH/2+1];$[MW/2-${#startPrevLabel}/2]f$fillL"
			printf "\e[$[MH/2+1];$[MW/2-${#startPrevLabel}/2]f$messageAuto"
			printf "\e[$[MH/2+3];$[MW/2-${#startPrevLabel}/2]f$fillL"
			printf "\e[$[MH/2+5];$[MW/2-${#startPrevLabel}/2]f$fillL\e[0m"
# auto game set sleep time
			printf "\e[$[MH/2+7];$[MW/2]f"
			re='^[0-9]+$'
			read -t 1.5 -n1 sleepTime
			if ! [[ $sleepTime =~ $re ]] || [[ -z $sleepTime ]]; then sleepTime=0; fi
			sleepTime=0.$sleepTime
			break
# saved game
		elif [[ "$keyS" == "s" ]]; then
			autorun=false
			loadSaved=true
			break
		fi
	done
# clear tty
	_STTY=$(stty -g)      # Save current terminal setup
	printf "\e[?25l"      # Turn of cursor
	stty -echo -icanon
}
