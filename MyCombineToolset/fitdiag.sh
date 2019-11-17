#! /bin/bash

cd /afs/cern.ch/work/m/msajatov/private/cms2/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -

CHANNEL=mt
VAR=dijetpt
ALGO=saturated
RMIN=-5
RMAX=5
ERA=2017


MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}
	
mkdir -p new

cp -a /afs/cern.ch/work/m/msajatov/private/cms2/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/CombineToolset/MyCombineToolset/fitdiag.sh new
cd new


combineTool.py -M T2W -o ${PWD}/${ERA}_workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS} | tee workspace.log
		        

PostFitShapesFromWorkspace -m 125 -w ${PWD}/${ERA}_workspace.root \
 -d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
 -o ${ERA}_datacard_shapes_prefit.root | tee postfitshapes_prefit.log
	            
combine -M FitDiagnostics -m 125 -d ${PWD}/${ERA}_workspace.root -n $ERA \
  --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic \
  --rMin $RMIN --rMax $RMAX -v 2 | tee postfitshapes_fit.log

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
 --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic \
 --rMin $RMIN --rMax $RMAX --plots -v 3 | tee gof_for_data.log

combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
 -n ".$ALGO.toys" --rMin $RMIN --rMax $RMAX \
 --cminDefaultMinimizerStrategy 0 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic \
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


