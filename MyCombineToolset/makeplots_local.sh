#! /bin/bash

cd /afs/cern.ch/work/m/msajatov/private/cms2/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -


VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 mt_2 pt_vis pt_tt mjj jdeta m_vis dijetpt met eta_1 eta_2"

SHORTVARS="mt_2"


MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}



for ERA in 2017 ; do    
	for VAR in ${VARS} ; do			  
		    
	    for CHANNEL in mt; do
	        for ALGO in saturated; do
	
	            mkdir -p gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
	            cd gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
	            
	            python /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/dev/utility/scripts/SystPlots/plotSyst.py \
		        -i ${ERA}_datacard_shapes_prefit.root -m $MASS -v $VAR -p png -s 0 -l 0
		        
		        python /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/dev/utility/scripts/SystPlots/plotSyst.py \
		        -i ${ERA}_datacard_shapes_postfit_sb.root -m $MASS -v $VAR -p png -s 0 -l 0
	            
	            
		        
	            cd ${BASEDIR}
	        done
    	done		
	done
done


