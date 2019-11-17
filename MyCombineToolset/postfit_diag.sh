#! /bin/bash

cd /afs/cern.ch/work/m/msajatov/private/cms2/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -

VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 mt_2 pt_vis pt_tt mjj jdeta m_vis dijetpt met eta_1 eta_2"

SHORTVARS="dijetpt"


MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}



for ERA in 2017 ; do    
	for VAR in ${VARS} ; do			  
		    
	    for CHANNEL in et mt tt; do
	        for ALGO in saturated; do
	
	            mkdir -p postfit_diag/${ERA}/${VAR}/${ALGO}/${CHANNEL}
	            cd postfit_diag/${ERA}/${VAR}/${ALGO}/${CHANNEL}
	
	            #combineTool.py -M T2W -o ${PWD}/workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/${MASS}/
	
	            # Throw toys
	            # combineTool.py -M GoodnessOfFit --algorithm $ALGO -m ${MASS} --there -d ${PWD}/workspace.root -n ".$ALGO.toys" -t 20 -s 1220:1269:1 --verbose 0 --rMin -5 --rMax 5 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0
	            
	            combineTool.py -M T2W -o ${PWD}/${ERA}_workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS} --parallel $NUM_THREADS | tee workspace.log

				PostFitShapesFromWorkspace -m 125 -w ${PWD}/${ERA}_workspace.root \
				-d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
				-o ${ERA}_datacard_shapes_prefit.root | tee postfitshapes_prefit.log
				
				combine -M FitDiagnostics -m 125 -d ${PWD}/${ERA}_workspace.root -n $ERA \
				--X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 \
				 | tee postfitshapes_fit.log
				
				PostFitShapesFromWorkspace --postfit -m 125 -w ${PWD}/${ERA}_workspace.root --skip-prefit \
				-d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
				-o ${ERA}_datacard_shapes_postfit_sb.root -f fitDiagnostics${ERA}.root:fit_s | tee postfitshapes_postfit.log
				
				PostFitShapesFromWorkspace --postfit -m 125 -w ${PWD}/${ERA}_workspace.root --skip-prefit \
				-d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
				-o ${ERA}_datacard_shapes_postfit_b.root -f fitDiagnostics${ERA}.root:fit_b | tee postfitshapes_postfit_bg_only.log
				
				
				combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root \
				-n ".$ALGO.data" \
				--X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 \
				--plots | tee gof_for_data.log
		        
		        python /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/dev/utility/scripts/SystPlots/plotSyst.py \
		        -i ${ERA}_datacard_shapes_prefit.root -m $MASS -v $VAR -p png -s 0 -l 0
		        
		        python /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/dev/utility/scripts/SystPlots/plotSyst.py \
		        -i ${ERA}_datacard_shapes_postfit_sb.root -m $MASS -v $VAR -p png -s 0 -l 0
		        
		        
	            cd ${BASEDIR}
	        done
    	done		
	done
done

