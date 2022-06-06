#!/bin/bash
## printMatrix.sh

# print frame
printFrame() {
	printf "\e[1;30;107m\e[$[pFh+1];$[pFw+1]f┌$colS┬$colS┬$colS┬$colS┐";
	printf "\e[$[pFh+2];$[pFw+1]f│\e[$[pFh+2];$[pFw+2+colW]f│\e[$[pFh+2];$[pFw+3+(colW*2)]f│\e[$[pFh+2];$[pFw+4+(colW*3)]f│\e[$[pFh+2];$[pFw+5+(colW*4)]f│";
	printf "\e[$[pFh+3];$[pFw+1]f├$colS┼$colS┼$colS┼$colS┤";
	printf "\e[$[pFh+4];$[pFw+1]f│\e[$[pFh+4];$[pFw+2+colW]f│\e[$[pFh+4];$[pFw+3+(colW*2)]f│\e[$[pFh+4];$[pFw+4+(colW*3)]f│\e[$[pFh+4];$[pFw+5+(colW*4)]f│";
	printf "\e[$[pFh+5];$[pFw+1]f├$colS┼$colS┼$colS┼$colS┤";
	printf "\e[$[pFh+6];$[pFw+1]f│\e[$[pFh+6];$[pFw+2+colW]f│\e[$[pFh+6];$[pFw+3+(colW*2)]f│\e[$[pFh+6];$[pFw+4+(colW*3)]f│\e[$[pFh+6];$[pFw+5+(colW*4)]f│";
	printf "\e[$[pFh+7];$[pFw+1]f├$colS┼$colS┼$colS┼$colS┤";
	printf "\e[$[pFh+8];$[pFw+1]f│\e[$[pFh+8];$[pFw+2+colW]f│\e[$[pFh+8];$[pFw+3+(colW*2)]f│\e[$[pFh+8];$[pFw+4+(colW*3)]f│\e[$[pFh+8];$[pFw+5+(colW*4)]f│";
	printf "\e[$[pFh+9];$[pFw+1]f└$colS┴$colS┴$colS┴$colS┘\e[0m";
	
	if [[ "$frameBottom" -eq "0" ]]; then
## print scores
		printf "\e[1;97;40m\e[$[pFh+4];$[pFw+matrixW+1]f Highscores:$fillHigh"
		printf "\e[$[pFh+5];$[pFw+matrixW+1]f$fillAllS"
		printf "\e[$[pFh+6];$[pFw+matrixW+1]f   ${fillScoreN[0]}  ${fillScoreS[0]}  "
		printf "\e[$[pFh+7];$[pFw+matrixW+1]f   ${fillScoreN[1]}  ${fillScoreS[1]}  "
		printf "\e[$[pFh+8];$[pFw+matrixW+1]f   ${fillScoreN[2]}  ${fillScoreS[2]}  "
		printf "\e[$[pFh+9];$[pFw+matrixW+1]f$fillAllS\e[0m"
	fi
}


# print number into fieds
printNumbers() {
	y=$[pFh+2]
	c=0
	for i in "${!matrix[@]}"; do 
		c=$[c+1]
		printM=${matrix[$i]}
		preMatrixLoop="matrix$[mainLoop-1][$i]"
		spacesGet=$[highestNumC-${#matrix[$i]}+4]
		spacesB=$(seq -s' ' $[spacesGet/2]|tr -d '[:digit:]')
		spacesA=$(seq -s' ' $[spacesGet-(spacesGet/2)]|tr -d '[:digit:]')
		x=$[pFw+c+((c-1)*colW)+1]
		ul=$y";"$x
		if [ $printM -eq "0" ]; then printM=" "; fi
# print if needed
		if [ $acHighestNum -ne $highestNumC ]; then
			printf "\e[1;30;107m\e[${ul}f$spacesB$printM$spacesA\e[0m";
		elif [[ "$reloadFrame" -eq "1" || "$printM" -ne "${!preMatrixLoop}" ]]; then
			printf "\e[1;30;107m\e[${ul}f$spacesB$printM$spacesA\e[0m";

		fi

		if (( $[i+1] % 4 == 0 )); then
			y=$[y+2]
			c=0
		fi
	done
	if [ $reloadFrame -eq 1 ]; then reloadFrame=0; fi
}

########
##MAIN##
printMatrix() {
	source matrix.log
	fillScore
	highestNumC=$(printf '%s\n' "${matrix[@]}" | awk '$1 > m || NR == 1 { m = $1 } END { print m }')
	highestNumC=${#highestNumC}
	colW=$[highestNumC+2]
	colS=$(seq -s'─' $[colW+1]|tr -d '[:digit:]')
	matrixW=$[$colW*4+5]
	
	if [[ "$frameBottom" -eq "0" ]]; then
		log "fuuuuu$frameBottom"
		pFh=$[MH/2-4]	
		pFw=$[MW/2-17]
	elif [[ "$frameBottom" -eq "1" ]]; then
## set framePosition
		pFh=$[MH-9]	
		pFw=0
	fi

## print actual score
	if [[ "$frameBottom" -eq "0" ]]; then
		printf "\e[1;97;40m\e[$[pFh+1];$[pFw+matrixW+1]f Your Score: $(IFS=+; echo "$((${matrix[*]}))") \e[0m"
	fi


	if [ -z $acHighestNum ] || [ $mainLoop -eq 0 ]; then 
		let acHighestNum=0
		printFrame
	elif [ $acHighestNum -ne $highestNumC ]; then
		printFrame
	fi
	printNumbers
	let acHighestNum=$highestNumC
}
