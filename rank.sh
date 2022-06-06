#!/bin/bash
## rank.sh

swipeValue=""
mainLoop=""
swipeXf=()

countMatrixZeros() {
        CZ=$(grep -ow 0 <<< "${countMx[*]}" | wc -l)
}

multiplyByZ() {
	countMatrixZeros
	mBz=$(echo "scale=2;$RV*((16-$CZ)*2/16)" | bc | awk '{print int($1)}')
}

getCornerR() {

	if [[ "$postArrC" -eq "0" || "$postArrC" -eq "3" || "$postArrC" -eq "12" || "$postArrC" -eq "15" ]]; then
	       if [[ "$tN" -ge "$tNO" ]]; then
			multiplyByZ
			GCRank[$swipeValue]=$((GCRank[swipeValue]+mBz))
	       fi
	fi
}

testPostArroundN() {
        setTestNnI=+1
        for postArrI in {0..1}; do
                if [ "$postArrI" -eq 1 ]; then
                        setTestNnI=+4
                fi
                for postArrC in {0..15}; do
                        tN=${matrix[$postArrC]}
                        tNO=${originalMx[$postArrC]}
                        tNnI=$postArrC"$setTestNnI"
                        tNn=${matrix[$tNnI]}
                        if [[ "$tN" -eq "0" ]]; then
                                RV=0
                        else
                                RV=$(echo "l($tN)/l(2)" | bc -l | awk '{print int($1)}')
                        fi
                        if [[ "$tNn" -eq "0" ]]; then
                                RnV=0
                        else
                                RnV=$(echo "l($tNn)/l(2)" | bc -l | awk '{print int($1)}')
                        fi
			if [ "$postArrI" -eq 0 ]; then
				getCornerR
			fi
                        if [[ -n "$tNn" ]]; then
                                if [[ "$tN" -gt "0" && "$tNn" -gt "$tN" ]]; then
                                        nPAr=$((RnV/((RnV/RV)*(RnV/RV))))
                                        #PARank[$swipeValue]=$((PARank[$swipeValue]+nPAr))
                                elif [[ "$tNn" -gt "0" && "$tN" -gt "$tNn" ]]; then
                                        nPAr=$((RV/((RV/RnV)*(RV/RnV))))
                                        #PARank[$swipeValue]=$((PARank[$swipeValue]+nPAr))
                                elif [[ "$tN" -gt "0" && "$tN" -eq "$tNn" ]]; then
                                        # multiply by part of left zeros
					mBz=0
					nPAr=$((mBz+RV))
                                        PARank[$swipeValue]=$((PARank[swipeValue]+nPAr))
                                fi
                        fi
                done
        done

}   

countEqualN() {
# uniqueValue countValue
	uVn=($(echo "${matrix[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
	#mapfile -t uVn < <(echo "${matrix[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
	uVn=("${uVn[@]:1}")
	uV=($(echo "${originalMx[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
	#mapfile -t uV < <(echo "${originalMx[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
	uV=("${uV[@]:1}")
	uVAuVn=("${uV[@]} ${uVn[@]}")
        uVAuVn=($(echo "${uVAuVn[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
	#$([ -n "$uV" ] && mapfile -t uVAuVn < <(echo "${uV[@]} ${uVn[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ') )
	log "$mainLoop: $uV, $uVn, $uVAuVn"
	uVi=()
	uVin=()
	for i in "${!uVAuVn[@]}"; do
		cVn=0
		cV=0
		for c in  "${!matrix[@]}"; do
			if [ "${uVAuVn[$i]}" -eq "${matrix[$c]}" ]; then
				cVn=$((cVn+1))
			else
				cVn=$((cVn+0))
			fi
			if [ "${uVAuVn[$i]}" -eq "${originalMx[$c]}" ]; then
				cV=$((cV+1))
			else
				cV=$((cV+0))
			fi
		done
		uVi[$i]=$cV
		uVin[$i]=$cVn
	done
	for rUvi in "${!uVAuVn[@]}"; do
		restUvA[$rUvi]=$((${uVin[$rUvi]}-${uVi[$rUvi]}))
		if [[ ${restUvA[$rUvi]} -gt 0 ]]; then
			uVAuVnI=$(echo "l(${uVAuVn[$rUvi]})/l(2)" | bc -l | awk '{print int($1)}')
			CERank[$swipeValue]=$((${CERank[$swipeValue]}+(${restUvA[$rUvi]}*uVAuVnI) ))
		else
			CERank[$swipeValue]=$((${CERank[$swipeValue]}+0))
		fi
	done

}

TRank() {
	TRank=(0 0 0 0)
	for totalC in {0..3}; do
		TRank[$totalC]=$((${CERank[$totalC]}+${PARank[$totalC]}+${GCRank[$totalC]}))
	done
}

getNextN() {
        PARank=(0 0 0 0)
	CERank=(0 0 0 0)
	GCRank=(0 0 0 0)
        for getXf in "${swipeXf[@]}"; do
                swpieC=${getXf}
                matrix=("${originalMx[@]}")
                $getXf
                swipeX
		countEqualN
                testPostArroundN
        done
}

getRank() {
        originalMx=("${matrix[@]}")
	countMx=("${matrix[@]}")
        getNextN
        TRank
        #log 1 "countEqRank: ${countEqRank[*]}"
        log 1 "GCRank: ${GCRank[*]}"
        log 2 "PARank: ${PARank[*]}"
        log 3 "total  Rank: ${TRank[*]}"
        matrix=("${originalMx[@]}")	
}
