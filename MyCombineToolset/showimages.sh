#! /bin/bash

VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 mt_2 pt_vis pt_tt mjj jdeta m_vis dijetpt met eta_1 eta_2"
#VARS="nbtag"


SHORTVARS="m_vis"

#CONFIGS="cc cc1 cc2 nn1 nn2 nn3 nn4 nn5 nn6 nn7 nn8 nn9 nn10 nn11 nn12 nn13 nn14 nn15 nn16 nn17 nn18 nn21 nn1a nn2a nn3a nn4a nn5a nn6a nn7a nn8a nn9a nn10a nn11a nn12a nn13a nn14a nn15a nn16a nn17a nn18a nn22a nn23a xx w tt"
CONFIGS="cc cc1 cc2 nn1 nn2 nn3 nn4 nn5 nn6 nn7 nn8 nn9 nn10 nn11 nn12 nn13 nn14 nn15 nn16 nn17 nn18 nn21 nn22 nn23 xx w tt"
#CONFIGS="cc"

MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}

ALGO=saturated

for ERA in 2017 ; do   
    for CHANNEL in et; do        
        for CONF in ${CONFIGS}; do
            for VAR in ${SHORTVARS} ; do             	            
                    
                cd ${CONF}/gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}

                #display "htt_${CHANNEL}_100_Run2017_postfit.png"
                echo "${CONF} --- ${VAR} --- channel ${CHANNEL}"

                mkdir -p "/eos/user/m/msajatov/wormhole/postfit/${CHANNEL}/${CONF}"
                cp "htt_${CHANNEL}_100_Run2017_postfit.png" "/eos/user/m/msajatov/wormhole/postfit/${CHANNEL}/${CONF}/htt_${CHANNEL}_${VAR}_100_Run2017_postfit.png"

                #mkdir -p "/eos/user/m/msajatov/wormhole/prefit/${CHANNEL}/${CONF}"
                #cp "htt_${CHANNEL}_100_Run2017_prefit.png" "/eos/user/m/msajatov/wormhole/prefit/${CHANNEL}/${CONF}/htt_${CHANNEL}_${VAR}_100_Run2017_prefit.png"
                
                cd ${BASEDIR}
            done    			
        done
    done
done