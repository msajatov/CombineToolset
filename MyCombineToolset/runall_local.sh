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
	            	            
	            
	            cp /afs/cern.ch/work/m/msajatov/private/cms2/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/CombineToolset/MyCombineToolset/runall_local.sh gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
				cd gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}


				combineTool.py -M T2W -o ${PWD}/${ERA}_workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS} | tee workspace.log
		        

				PostFitShapesFromWorkspace -m 125 -w ${PWD}/${ERA}_workspace.root \
				 -d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
				 -o ${ERA}_datacard_shapes_prefit.root | tee postfitshapes_prefit.log
					            
				combine -M FitDiagnostics -m 125 -d ${PWD}/${ERA}_workspace.root -n $ERA \
				 -v 2 | tee postfitshapes_fit.log
				
				PostFitShapesFromWorkspace --postfit -m 125 -w ${PWD}/${ERA}_workspace.root --skip-prefit \
				 -d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
				 -o ${ERA}_datacard_shapes_postfit_sb.root -f fitDiagnostics${ERA}.root:fit_s | tee postfitshapes_postfit.log
				
				PostFitShapesFromWorkspace --postfit -m 125 -w ${PWD}/${ERA}_workspace.root --skip-prefit \
				 -d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
				 -o ${ERA}_datacard_shapes_postfit_b.root -f fitDiagnostics${ERA}.root:fit_b | tee postfitshapes_postfit_bg_only.log
				
				python /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/dev/utility/scripts/SystPlots/plotSyst.py \
				 -i ${ERA}_datacard_shapes_prefit.root -m $MASS -v $VAR -p png -s 0 -l 0
				
				python /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/dev/utility/scripts/SystPlots/plotSyst.py \
				 -i ${ERA}_datacard_shapes_postfit_sb.root -m $MASS -v $VAR -p png -s 0 -l 0
				
				
				combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root -n ".$ALGO.data" \
				 --plots -v 3 | tee gof_for_data.log
				
				combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
				 -n ".$ALGO.toys"  \
				 -s 1230:1249:1 -t $TOYS \
				 --parallel ${NUM_THREADS} -v 0 | tee gof_for_toys.log
				 
				combineTool.py -M CollectGoodnessOfFit \
				    --input higgsCombine.${ALGO}.data.GoodnessOfFit.mH$MASS.root \
				        higgsCombine.${ALGO}.toys.GoodnessOfFit.mH$MASS.*.root \
				    --output gof.json | tee collect.log				    
				
				# Plot
				plotGof.py --statistic ${ALGO} --mass $MASS.0 --output gof gof.json
  

				/afs/cern.ch/work/m/msajatov/private/cms2/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/CombineToolset/MyCombineToolset/grepdata.sh
		        
	            cd ${BASEDIR}
	        done
    	done
    	
    	for CHANNEL in mt; do
	        for ALGO in KS AD; do
	
	            mkdir -p gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
	            	            
	            
	            cp /afs/cern.ch/work/m/msajatov/private/cms2/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/CombineToolset/MyCombineToolset/runall_local.sh gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
				cd gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}


				combineTool.py -M T2W -o ${PWD}/${ERA}_workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS} | tee workspace.log
		        				
				combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root -n ".$ALGO.data" \
				 --plots -v 3 | tee gof_for_data.log
				
				combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
				 -n ".$ALGO.toys"  \
				 -s 1230:1249:1 -t $TOYS \
				 --parallel ${NUM_THREADS} -v 0 | tee gof_for_toys.log
				 
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



#-------------------------GOF------------------------------#

#combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root \
#		        -n ".$ALGO.data" \
#		        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 \
#		        --plots | tee gof_for_data.log

#combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
#		         -n ".$ALGO.toys" \
#		         -s 1230:1249:1 -t $TOYS \
#		         --parallel $NUM_THREADS \
#		         --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 \
#		         | tee gof_for_toys.log

#----------------------------GOFTEST1-------------------------#
		        
#		        combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root \
#		        -n ".$ALGO.data" \
#		        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		        --plots | tee gof_for_data.log
#		        
#		        combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
#		         -n ".$ALGO.toys" \
#		         -s 1230:1249:1 -t $TOYS \
#		         --parallel $NUM_THREADS \
#		         --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		         | tee gof_for_toys.log


#-----------------------------GOFTEST2-------------------------#


#combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root \
#		        -n ".$ALGO.data" --rMin -2. --rMax 2 \
#		        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		        --plots | tee gof_for_data.log
#		        
#		        combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
#		         -n ".$ALGO.toys" --rMin -2. --rMax 2 \
#		         -s 1230:1249:1 -t $TOYS \
#		         --parallel $NUM_THREADS \
#		         --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		         | tee gof_for_toys.log


#----------------------------GOFTEST3-------------------------#

#combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root \
#		        -n ".$ALGO.data" --rMin -5 --rMax 5 \
#		        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		        --plots | tee gof_for_data.log
#		        
#		        combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
#		         -n ".$ALGO.toys" --rMin -5 --rMax 5 \
#		         -s 1230:1249:1 -t $TOYS \
#		         --parallel $NUM_THREADS \
#		         --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		         | tee gof_for_toys.log


#------------------------------GOFTEST4--------------------------#

#combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root \
#		        -n ".$ALGO.data" --rMin -5 --rMax 5 \
#		        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		        --plots --trackParameters r | tee gof_for_data.log
#		        
#		        combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
#		         -n ".$ALGO.toys" --rMin -5 --rMax 5 \
#		         -s 1230:1249:1 -t $TOYS \
#		         --parallel $NUM_THREADS \
#		         --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		         --trackParameters r | tee gof_for_toys.log


#----------------------------GOFTEST5------------------------------#

#combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root \
#		        -n ".$ALGO.data" --rMin -5 --rMax 5 \
#		        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		        --plots | tee gof_for_data.log
#		        
#		        combine -M FitDiagnostics -m $MASS -d ${PWD}/${ERA}_workspace.root -n $ERA \
#	            --X-rtd MINIMIZER_analytic --X-rtd FITTER_NEW_CROSSING_ALGO --cminDefaultMinimizerStrategy 0 \
#	            --rMin -5 --rMax 5 | tee fit_diagnostics.log
#		        
#		        combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
#		         -n ".$ALGO.toys" --rMin -5 --rMax 5 \
#		         -s 1230:1249:1 -t $TOYS \
#		         --parallel $NUM_THREADS \
#		         --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
#		          | tee gof_for_toys.log

