#!/bin/bash

### functions.sh

source scores
source printstart.sh
source gameover.sh
source matrix.log
source rank.sh

swipeXf=(swipeA swipeB swipeC swipeD)
newSwipeState=(false false false false)
swipeL=0
MW=$(tput cols)
MH=$(tput lines)

log() {
	msg=$1
	add=$2
	echo "$msg##$add" >> log.log

	re='^[0-9]+$'
	if [[ $msg =~ $re ]] ; then
		printf "\e[1;47;30m"
		printf "\e[$((MH/2+5+msg));1f$(seq -s' ' $((MW+1))|tr -d '[:digit:]')"
		printf "\e[$((MH/2+5+msg));$((MW/2-16))f  $add  "
		printf "\e[0m"
	fi
}
logMatrix() {
	echo "matrix$mainLoop=(${matrix[*]})" >> matrix.log
}

swipeA() {
	keyP=A
	swipeValue=0
	swipeN=$((4+swipeL))
	swipeSetNn=-4
}
swipeB() {
	keyP=B
	swipeValue=1
	swipeSetNn=+4
	swipeN=$((11-swipeL))
}
swipeC() {
	keyP=C
	swipeValue=2
	swipeSetNn=+1
	swipeN=$(( ((swipeL/-4 ) + 2) + ((swipeL-((swipeL/4)*4))*4) ))
}
swipeD() {
	keyP=D
	swipeValue=3
	swipeSetNn=-1
	swipeN=$(( (swipeL/4) + ((swipeL - ((swipeL/4)*4))*4) +1))
}

ran16() {
	echo $(( ( RANDOM % 16 )  + 0 ))
}

ran2o4() {
	# get 2(80%) or 4(20%)
	if [ $((( RANDOM % 100 ) + 1 )) -le 80 ]; then
		echo 2
	else
		echo 4
	fi
}

waitForKey() {
	while true; do
		read -rsn3 -d '' PRESS
		keyP=${PRESS:2}
		if [[ "$keyP" = "A" || "$keyP" = "B" || "$keyP" = "C" || "$keyP" = "D" ]]; then
			break
		fi
	done
}

swipeX() {
	for i in {0..3}; do
		for swipeL in {0..11}; do
			swipe"$keyP"
			swipeNn=$((swipeN+swipeSetNn))
			if [[ "${matrix[$swipeNn]}" -eq "0" && "${matrix[$swipeN]}" -gt "0" || 
			   "${matrix[$swipeN]}" -gt  "0" && "${matrix[$swipeN]}" -eq "${matrix[swipeNn]}" ]]; then
				swipeState[$swipeValue]=true
				matrix[$swipeNn]=$((matrix[swipeN]+matrix[swipeNn]))
				matrix[$swipeN]="0"
			fi
		done	
	done
}

testSwipe() {
	swipeState=("${newSwipeState[@]}")
        testSwipeMx=("${matrix[@]}")
	log "TS:$mainLoop: ${matrix[*]}"
	for testX in "${swipeXf[@]}"; do
		$testX	
		matrix=("${testSwipeMx[@]}")
		swipeX
	done
        matrix=("${testSwipeMx[@]}")

	if [[ "$mainLoop" -gt "0" && $(printf "%s\000" "${swipeState[@]}" |
			LC_ALL=C sort -z -u | grep -z -c .) -eq 1 ]]; then
		if [ ${swipeState[0]} = false ]; then 
			setHighscore
	       	fi
	fi
}

setRanN() {
	while true; do
		setRanN=$(ran16)
		if [ ${matrix[$setRanN]} -eq 0 ]; then
			matrix[$setRanN]=$(ran2o4)
			break
		fi	
	done
}

fillScore() {
	fillScoreS=("" "" "")
	fillScoreN=("" "" "")
	longestScore=${scores[0]}
	longestName=$(echo "${scoreNames[*]}" | sed 's/ /\n/g' | sort | uniq | awk '{print length, $0}' | sort -nr | head -n 1 | awk '{print $NF}')
	fillAll=$((${#longestScore}+${#longestName}+8))
	fillAllS=$(seq -s' ' $fillAll|tr -d '[:digit:]')
	fillHigh=$(seq -s' ' $((fillAll-12))|tr -d '[:digit:]')
	for fillS in {0..2}; do
		spacesFs=$((${#longestScore}-${#scores[$fillS]}+1))
		spacesFn=$((${#longestName}-${#scoreNames[$fillS]}+1))
		fillSpaceS=$(seq -s' ' $spacesFs|tr -d '[:digit:]')
		fillSpaceN=$(seq -s' ' $spacesFn|tr -d '[:digit:]')
		fillScoreS[$fillS]="$fillSpaceS${scores[$fillS]}"
		fillScoreN[$fillS]="${scoreNames[$fillS]}$fillSpaceN"
	done
}

blackScreen() {
	for ((i = 0 ; i <= MH ; i++)); do
		printf "\e[37;40m%$((MW))s\e[0m" |tr " " " "
	done

}

startRun() {
	matrix=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	mainLoop=0
	blackScreen
	printStart
	blackScreen
	if [ "$loadSaved" = "true" ]; then
		log "loadSaved: $loadSaved"
		oldMx=$(tail -n 1 matrix.log | grep -o -P '(?<=\().*(?=\))')
		IFS=', ' read -r -a matrix <<< "$oldMx"
		mainLoop=$(tail -n 1 matrix.log | grep -o -P '(?<=x).*(?==)')
	else
		rm matrix.log >> /dev/null 2>&1
		setRanN
		setRanN
		logMatrix
	fi
	reloadFrame=1
	log "$mainLoop, ${matrix[*]}"
	printMatrix
}


