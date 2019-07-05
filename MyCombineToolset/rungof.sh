#! /bin/bash

cd /afs/hephy.at/work/m/msajatovic/cms/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -


VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 pt_tt mjj jdeta m_vis dijetpt met eta_1 eta_2"

SHORTVARS="pt_1"


MASS=125
TOYS=1
NUM_THREADS=4
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}



for ERA in 2017 ; do    
	for VAR in ${SHORTVARS} ; do			  
		    
	    for CHANNEL in tt ; do
	        for ALGO in saturated ; do
	
	            mkdir -p gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
	            cd gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
	
	            #combineTool.py -M T2W -o ${PWD}/workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/${MASS}/
	
	            # Throw toys
	            # combineTool.py -M GoodnessOfFit --algorithm $ALGO -m ${MASS} --there -d ${PWD}/workspace.root -n ".$ALGO.toys" -t 20 -s 1220:1269:1 --verbose 0 --rMin -5 --rMax 5 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0
	            
	            
	            
	            combineTool.py -M T2W -o ${PWD}/${ERA}_workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/${MASS} --parallel $NUM_THREADS | tee workspace.log
	            
	            combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root \
		        -n ${ERA} \
		        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 \
		        --plots | tee gof_for_data.log
	            cd ${BASEDIR}
	        done
    	done		
	done
done