#! /bin/bash

VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 mt_2 pt_vis pt_tt mjj jdeta m_vis dijetpt met"
#VARS="nbtag"
SHORTVARS="mt_2"

ch=$1
shift
arr=( "$@" )
CONFIGS="${arr[@]}"

# channels=('et' 'mt' 'tt')

if [ $ch == "et" ]; then
    CHANNELS="et"
elif [ $ch == "mt" ]; then
    CHANNELS="mt"
elif [ $ch == "tt" ]; then
    CHANNELS="tt"
else
    CHANNELS=('et' 'mt' 'tt')
fi


#CONFIGS="cc cc1 cc2 nn1 nn2 nn3 nn4 nn5 nn6 nn7 nn8 nn9 nn10 nn11 nn12 nn13 nn14 nn15 nn16 nn17 nn18 nn21 nn1a nn2a nn3a nn4a nn5a nn6a nn7a nn8a nn9a nn10a nn11a nn12a nn13a nn14a nn15a nn16a nn17a nn18a nn22a nn23a xx w tt"
#CONFIGS="cc cc1 cc2 nn1 nn2 nn3 nn4 nn5 nn6 nn7 nn8 nn9 nn10 nn11 nn12 nn13 nn14 nn15 nn16 nn17 nn18 nn21 nn22 nn23 xx w tt"
# CONFIGS="snn47 snn48 snn49 snn50 snn51 snn52 snn53"
# CONFIGS="snn53"
# CONFIGS="snn54 snn55"

MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}

ALGO=saturated

for ERA in 2017 ; do   
    for CHANNEL in "${CHANNELS[@]}"; do          
        for CONF in ${CONFIGS}; do
        # shopt -s dotglob
        # find * -prune -type d | while IFS= read -r d; do 
        #     if [ $d != "output" ]; then
                for VAR in ${VARS} ; do  
                        if [ -d ${CONF}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL} ]; then
                            #echo "Entering" ${CONF}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL} "..."
                            cd ${CONF}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
                            #cd ${d}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}

                            #display "htt_${CHANNEL}_100_Run2017_postfit.png"

                            TEXT=$(grep "FVAL  = 0" grepoutput.log)                
                            if [ "$TEXT" != "" ]; then
                                echo "${CONF} --- ${VAR} --- channel ${CHANNEL}"
                                echo $TEXT
                                echo "----------------------------------------"
                            fi

                            TEXT=$(grep "Status : MINIMIZE" postfitshapes_fit.log | grep -v "Status : MINIMIZE=0")                
                            if [ "$TEXT" != "" ]; then
                                echo "${CONF} --- ${VAR} --- channel ${CHANNEL}"
                                echo $TEXT
                                grep "FVAL  =" grepoutput.log
                                grep "RooFitResult: minimized FCN value:" grepoutput.log
                                echo "----------------------------------------"
                            fi

                            TEXT=$(grep "Fit failed" postfitshapes_fit.log)                
                            if [ "$TEXT" != "" ]; then
                                echo "${CONF} --- ${VAR} --- channel ${CHANNEL}"
                                echo $TEXT
                                grep "INFO:\|DEBUG:\|ERROR:" postfitshapes_fit.log
                                echo "----------------------------------------"
                            fi

                            #echo "${CONF} --- ${VAR} --- channel ${CHANNEL}"

                            #grep "FVAL  =" grepoutput.log
                            #grep "RooFitResult: minimized FCN value:" grepoutput.log
                            #grep "Best fit r" grepoutput.log
                            #grep "FVAL  = 0" grepoutput.log

                            #echo "----------------------------------------"
                            
                            cd ${BASEDIR}
                        else
                            echo "Directory" ${CONF}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL} "does not exist!"
                        fi

                        if [ -d ${CONF}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}_fail ]; then
                            echo "Entering" ${CONF}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}_fail "..."
                            cd ${CONF}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}_fail
                            #cd ${d}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}

                            #display "htt_${CHANNEL}_100_Run2017_postfit.png"

                            TEXT=$(grep "FVAL  = 0" grepoutput.log)                
                            if [ "$TEXT" != "" ]; then
                                echo "${CONF} --- ${VAR} --- channel ${CHANNEL}"
                                echo $TEXT
                                echo "----------------------------------------"
                            fi

                            TEXT=$(grep "Status : MINIMIZE" postfitshapes_fit.log | grep -v "Status : MINIMIZE=0")                
                            if [ "$TEXT" != "" ]; then
                                echo "${CONF} --- ${VAR} --- channel ${CHANNEL}"
                                echo $TEXT
                                grep "FVAL  =" grepoutput.log
                                grep "RooFitResult: minimized FCN value:" grepoutput.log
                                echo "----------------------------------------"
                            fi

                            TEXT=$(grep "Fit failed" postfitshapes_fit.log)                
                            if [ "$TEXT" != "" ]; then
                                echo "${CONF} --- ${VAR} --- channel ${CHANNEL}"
                                echo $TEXT
                                grep "INFO:\|DEBUG:\|ERROR:" postfitshapes_fit.log
                                echo "----------------------------------------"
                            fi

                            #echo "${CONF} --- ${VAR} --- channel ${CHANNEL}"

                            #grep "FVAL  =" grepoutput.log
                            #grep "RooFitResult: minimized FCN value:" grepoutput.log
                            #grep "Best fit r" grepoutput.log
                            #grep "FVAL  = 0" grepoutput.log

                            #echo "----------------------------------------"
                            
                            cd ${BASEDIR}
                        fi
                done   	
            # fi
        done
    done
done