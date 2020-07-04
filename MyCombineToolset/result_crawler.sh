#! /bin/bash

VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 mt_2 pt_vis pt_tt mjj jdeta m_vis dijetpt met"
#VARS="nbtag"
SHORTVARS="mt_2"

SEEDS="1230:1249:1 1250:1269:1 1270:1289:1 1290:1309:1 1310:1329:1 1330:1349:1 1350:1369:1 1370:1389:1 1390:1409:1 1410:1429:1 1430:1449:1 1450:1469:1 1470:1489:1 1490:1509:1 1510:1529:1 1530:1549:1 1550:1569:1 1570:1589:1 1590:1609:1 1610:1629:1"

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

BASEDIR=${PWD}

ALGOS="saturated"

for ERA in 2017 ; do   
    for CHANNEL in "${CHANNELS[@]}"; do          
        for CONF in ${CONFIGS}; do

            for SEED in ${SEEDS}; do
                for VAR in ${VARS} ; do             	            
                    for ALGO in ${ALGOS}; do
                        if [ -d ${CONF}/gof/${SEED}/${ERA}/${VAR}/${ALGO}/${CHANNEL} ]; then
                            cd ${CONF}/gof/${SEED}/${ERA}/${VAR}/${ALGO}/${CHANNEL}                        

                            TEXT=$(grep "FVAL  = 0" gof_for_data.log)                
                            if [ "$TEXT" != "" ]; then
                                echo "${CONF} --- ${VAR} --- channel ${CHANNEL} --- algo ${ALGO} --- seed ${SEED}"
                                echo $TEXT
                                echo "----------------------------------------"
                            fi
                            
                            cd ${BASEDIR}
                        else
                            echo "Directory" ${CONF}/gof/${SEED}/${ERA}/${VAR}/${ALGO}/${CHANNEL} "does not exist!"
                        fi
                    done
                done    

            done
        done
    done
done