#!/bin/bash
## gameover.sh


centerG=$[MW/2-26]



gameover() {
	source functions.sh
	fillScore



	printf "\e[37;40m\e[1;$[centerG]f█████▀████████████████████████████████████████████"
	printf "\e[2;$[centerG]f█ ▄▄▄▄██▀▄ ██▄ ▀█▀ ▄█▄ ▄▄ █ ▄▄ █▄ █ ▄█▄ ▄▄ █▄ ▄▄▀█"
	printf "\e[3;$[centerG]f█ ██▄ ██ ▀ ███ █▄█ ███ ▄█▀█ ██ ██▄▀▄███ ▄█▀██ ▄ ▄█"
	printf "\e[4;$[centerG]f█▄▄▄▄▄█▄▄█▄▄█▄▄▄█▄▄▄█▄▄▄▄▄█▄▄▄▄███▄███▄▄▄▄▄█▄▄█▄▄█\e[0m"

	scoreP="  Your Score: $(IFS=+; echo "$((${matrix[*]}))")"
	fillScoreP=$[${#fillAllS}-${#scoreP}]
	fillScoreP=$(seq -s' ' $[${#fillAllS}-${#scoreP}]|tr -d '[:digit:]')
	score0="   ${fillScoreN[0]}  ${fillScoreS[0]}   "
	score1="   ${fillScoreN[1]}  ${fillScoreS[1]}   "
	score2="   ${fillScoreN[2]}  ${fillScoreS[2]}   "
	printW=$[MW/2-${#fillAllS}/2-1]
# fillOverflow
	if [ ${#scoreP} -gt $[${#fillAllS}-1] ]; then
		fillO=$(seq -s' ' $[${#scoreP}+3]|tr -d '[:digit:]')
		printW=$[MW/2-${#scoreP}/2-1]
		for i in {0..7}; do
			printf "\e[1;47;30m\e[$[MH/2-4+$i];$[printW]f$fillO\e[0m"
		done
	elif [ ${#scoreP} -lt $[${#fillAllS}-1] ]; then
		printf "\e[1;47;30m\e[$[MH/2-3];$[printW+${#scoreP}]f$fillO\e[0m"

	fi
	printf "\e[1;47;30m\e[$[MH/2-4];$[printW]f$fillAllS "
	printf "\e[$[MH/2-3];$[printW]f$scoreP  $fillScoreP"
	printf "\e[$[MH/2-2];$[printW]f$fillAllS "
	printf "\e[$[MH/2-1];$[printW]f  Highscores:$fillHigh"
	printf "\e[$[MH/2];$[printW]f$score0"
	printf "\e[$[MH/2+1];$[printW]f$score1"
	printf "\e[$[MH/2+2];$[printW]f$score2"
	printf "\e[$[MH/2+3];$[printW]f$fillAllS \e[0m"


	restartT=" Restart by pressing Enter"
	exitT=" Exit by pressing CTRL-C    "
	printf "\e[1;40;37m\e[$[MH-1];$[MW/2-${#restartT}/2]f$restartT"
	printf "\e[$[MH];$[MW/2-${#restartT}/2]f$exitT\e[0m"

	read -rs
	frameBottom=0
	acHighestNum=1
	startRun
}

readScoreName() {

        centerH=$[MW/2-24]

        printf "\e[37;40m\e[1;$[centerH]f█████████████▀██████████████████████████████████"
        printf "\e[2;$[centerH]f█ █ █▄ ▄█ ▄▄▄▄█ █ █ ▄▄▄▄█ ▄▄▄ █ ▄▄ █▄ ▄▄▀█▄ ▄▄ █"
        printf "\e[3;$[centerH]f█ ▄ ██ ██ ██▄ █ ▄ █▄▄▄▄ █ ███▀█ ██ ██ ▄ ▄██ ▄█▀█"
        printf "\e[4;$[centerH]f█▄█▄█▄▄▄█▄▄▄▄▄█▄█▄█▄▄▄▄▄█▄▄▄▄▄█▄▄▄▄█▄▄█▄▄█▄▄▄▄▄█\e[0m"

        nameLabel="   Enter your name:   "
        printf "\e[1;47;30m\e[$[MH/2-1];$[MW/2-${#nameLabel}/2]f$(seq -s' ' $[${#nameLabel}+1]|tr -d '[:digit:]')\e[0m"
        printf "\e[1;47;30m\e[$[MH/2];$[MW/2-${#nameLabel}/2]f$nameLabel\e[0m"
        printf "\e[1;47;30m\e[$[MH/2+1];$[MW/2-${#nameLabel}/2]f$(seq -s' ' $[${#nameLabel}+1]|tr -d '[:digit:]')\e[0m"
        printf "\e[1;47;30m\e[$[MH/2+2];$[MW/2-${#nameLabel}/2]f$(seq -s' ' $[${#nameLabel}+1]|tr -d '[:digit:]')\e[0m"
        printf "\e[$[MH/2+1];$[MW/2-${#nameLabel}/2+3]f"
        read pName
	pName=$(echo $pName | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]' | sed -e "s/[[:space:]]\+/ /g")
}

setHighscore() {
        newScore=$(IFS=+; echo "$((${matrix[*]}))")
        newScores=("${scores[@]}")
        newScoreNames=("${scoreNames[@]}")
        setC=-1
        breakSet=true


        blackScreen
	frameBottom=1
	acHighestNum=1
	printMatrix
        for ((setC=0;setC<3;setC++)); do
                if [ $breakSet = true ]; then
                        if [[ "$newScore" -gt "${scores[$setC]}" ]]; then
                                if $autorun; then pName="autorun"; echo $pName;  else
                                        readScoreName
                                fi
                                for ((n=$setC;n<2;n++)); do
                                        newScores[$((n+1))]=${scores[$n]}
                                        newScoreNames[$((n+1))]="${scoreNames[$n]}"
                                done 
                                newScores[$setC]=$newScore
                                newScoreNames[$setC]="$pName"
                                breakSet=false
                        fi
                fi
        done
	echo "scores=(${newScores[*]})" > scores
	echo "scoreNames=(${newScoreNames[*]})" >> scores
        gameover
	loadSaved=false
}
                                   
