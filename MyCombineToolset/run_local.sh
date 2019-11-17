#! /bin/bash

cd /afs/cern.ch/work/m/msajatov/private/cms2/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -

CHANNEL=$1
VAR=$2
ALGO=$3
ERA=2017


MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}
	
mkdir -p gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}
cd gof/${ERA}/${VAR}/${ALGO}/${CHANNEL}

#combineTool.py -M T2W -o ${PWD}/workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/${MASS}/

# Throw toys
# combineTool.py -M GoodnessOfFit --algorithm $ALGO -m ${MASS} --there -d ${PWD}/workspace.root -n ".$ALGO.toys" -t 20 -s 1220:1269:1 --verbose 0 --rMin -5 --rMax 5 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0



combineTool.py -M T2W -o ${PWD}/${ERA}_workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS} --parallel $NUM_THREADS | tee workspace.log
		        
combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
 -n ".$ALGO.toys" --rMin -100 --rMax 100 \
 -s 1230:1249:1 -t $TOYS \
 --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO \
 --parallel ${NUM_THREADS} | tee gof_for_toys.log
 
 combine -M FitDiagnostics -m $MASS -d ${PWD}/${ERA}_workspace.root -n $ERA \
--X-rtd MINIMIZER_analytic --X-rtd FITTER_NEW_CROSSING_ALGO --cminDefaultMinimizerStrategy 0 \
--rMin -100 --rMax 100 | tee fit_diagnostics.log

combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root -n ".$ALGO.data" \		          \
--X-rtd MINIMIZER_analytic --X-rtd FITTER_NEW_CROSSING_ALGO --cminDefaultMinimizerStrategy 0 \
--rMin -100 --rMax 100 --plots | tee gof_for_data.log
 
 combineTool.py -M CollectGoodnessOfFit \
    --input higgsCombine.${ALGO}.data.GoodnessOfFit.mH$MASS.root \
        higgsCombine.${ALGO}.toys.GoodnessOfFit.mH$MASS.*.root \
    --output gof.json | tee collect.log				    

  # Plot
  plotGof.py --statistic ${ALGO} --mass $MASS.0 --output gof gof.json

cd ${BASEDIR}



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

