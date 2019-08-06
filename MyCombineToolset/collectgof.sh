#! /bin/bash

cd /afs/cern.ch/work/m/msajatov/private/cms/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -


VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 mt_2 pt_vis pt_tt mjj jdeta m_vis dijetpt met eta_1 eta_2"

SHORTVARS="pt_vis"


MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}



for ERA in 2017 ; do    
	for VAR in ${VARS} ; do			  
		    
	    for CHANNEL in et mt tt; do
	        for ALGO in saturated KS AD; do
	
	            mkdir -p gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
	            cd gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}	            
		         
		         combineTool.py -M CollectGoodnessOfFit \
				    --input higgsCombine.${ALGO}.data.GoodnessOfFit.mH$MASS.root \
				        higgsCombine.${ALGO}.toys.GoodnessOfFit.mH$MASS.*.root \
				    --output gof.json | tee collect.log
			
				  # Plot
				  plotGof.py --statistic ${ALGO} --mass $MASS.0 --output gof gof.json
		        
	            cd ${BASEDIR}
	        done
    	done		
	done
done