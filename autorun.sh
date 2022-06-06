### autorun.sh

setSwipeDirection() {
	swipeWhile=true
	sCc=0
	while [ "$swipeWhile" = "true" ]; do
		sCc=$((sCc+1))
		maxRank=$(printf '%s\n' "${TRank[@]}" | sort -n | tail -$sCc | head -1)
		for setSwipeC in {0..3}; do
			if [[ ${TRank[$setSwipeC]} -eq $maxRank && ${swipeState[$setSwipeC]} ]]; then
				if ${swipeState[$setSwipeC]}; then
					directionX=$setSwipeC
					log "if1b: $setSwipeC, ${swipeState[*]}"
					swipeWhile=false
				fi
			fi
			
		done

		if [ $sCc -eq 4 ]; then
			testSwipe
			swipeWhile=false
		fi
	done
}



########
##MAIN##
runAutoMx() {
	getRank
	setSwipeDirection
	${swipeXf[$directionX]}
}
