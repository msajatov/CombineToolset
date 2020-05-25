#! /bin/bash

LOGFILE=${PWD}/fitstatus.log

echo $LOGFILE

VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 mt_2 pt_vis pt_tt mjj jdeta m_vis dijetpt met eta_1 eta_2"

SHORTVARS="mt_2"

CONFIGS="cc cc1 cc2 nn1 nn2 nn3 nn4 nn5 nn6 nn7 nn8 nn9 nn10 nn11 nn12 nn13 nn14 nn15 nn16 nn17 nn18 nn21 nn1a nn2a nn3a nn4a nn5a nn6a nn7a nn8a nn9a nn10a nn11a nn12a nn13a nn14a nn15a nn16a nn17a nn18a nn22a nn23a xx w tt"

MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}



for ERA in 2017 ; do   
    for CHANNEL in tt; do
        for CONF in ${CONFIGS}; do
            for VAR in ${VARS} ; do            
                for ALGO in saturated; do	            	            
                    
                    cd ${CONF}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}

                    if grep -i "Messages of type DEBUG :" gof_for_data.log | grep -v "0" ; then
                        echo "${CONF} --- ${VAR} --- channel ${CHANNEL}" |& tee -a $LOGFILE
                        grep -i "Messages of type DEBUG :" gof_for_data.log |& tee -a $LOGFILE


                        if grep -i "DEBUG:" gof_for_data.log; then
                            grep -i "DEBUG:" gof_for_data.log |& tee -a $LOGFILE
                        fi

                        echo "------------------------------------------------------" |& tee -a $LOGFILE
                    fi

                    #if grep -i "Minimization ended with latest status != 0 or 1" gof_for_data.log; then
                     #   echo "${CONF} --- ${VAR} --- channel ${CHANNEL}" |& tee -a $LOGFILE
                      #  grep -i "Minimization ended with latest status != 0 or 1" gof_for_data.log |& tee -a $LOGFILE
                       # echo "------------------------------------------------------" |& tee -a $LOGFILE
                    #fi
                    
                    cd ${BASEDIR}
                done
            done    			
        done
    done
done