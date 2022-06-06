#!/bin/bash
### 2048.sh

param=$1
sleepTime=$2
if [ -z "$sleepTime" ]; then sleepTime=0.0; fi
source functions.sh
source printMatrix.sh
source autorun.sh
rm log.log
clear -x

#_STTY=$(stty -g)      # Save current terminal setup
#printf "\e[?25l"      # Turn of cursor
#stty -echo -icanon


function at_exit() {
	printf "\e[?9l"          # Turn off mouse reading
        printf "\e[?12l\e[?25h"  # Turn on cursor
        stty "$_STTY"            # reinitialize terminal settings
	tput sgr0
	clear -x
}
trap at_exit ERR EXIT

autorun=false
if [ "$param" = "-a" ]; then
	autorun=true
	source autorun.sh
fi


startRun

########
##MAIN##
while true; do
	mainLoop=$((mainLoop+1))
	swipeState=("${newSwipeState[@]}")
	frameBottom=0


	log "main:$mainLoop: ${matrix[*]}"
	getRank
# auto or user
	if $autorun; then
		runAutoMx
	else
		waitForKey
	fi
# swipe to direction X
	swipeX
# set Random num matrix
	#if $setNewRanN; then setRanN && wait; fi
	if ${swipeState[$swipeValue]}; then setRanN; fi
# write matrix
	logMatrix
	if $autorun; then sleep $sleepTime; fi
	printMatrix

# test 
	testSwipe
done
