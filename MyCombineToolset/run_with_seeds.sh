#! /bin/sh

cd /afs/cern.ch/work/m/msajatov/private/cms3/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -

CHANNEL=$1
ERA=$2
VAR=$3
ALGO=$4
SEEDS=$5

BASEDIR=${PWD}

MASS=125
TOYS=25
# do NOT try to set this to anything else (CombineToolBase modified so it only expects one process)
# this was done to prevent strange issues with mp.Pool
NUM_THREADS=1


mkdir -p gof/${SEEDS}/${ERA}/${VAR}/${ALGO}/${CHANNEL}	            
cp /afs/cern.ch/work/m/msajatov/private/cms3/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/CombineToolset/MyCombineToolset/run_with_arguments.sh gof/${SEEDS}/${ERA}/${VAR}/${ALGO}/${CHANNEL}
cd gof/${SEEDS}/${ERA}/${VAR}/${ALGO}/${CHANNEL}

combineTool.py -M T2W -o ${PWD}/${ERA}_workspace.root -i ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS} |& tee workspace.log

# if [ ${ALGO} == saturated ]; then
#     PostFitShapesFromWorkspace -m 125 -w ${PWD}/${ERA}_workspace.root \
#         -d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
#         -o ${ERA}_datacard_shapes_prefit.root |& tee postfitshapes_prefit.log
                    
#     combine -M FitDiagnostics -m 125 -d ${PWD}/${ERA}_workspace.root -n $ERA \
#         -v 2 |& tee postfitshapes_fit.log

#     PostFitShapesFromWorkspace --postfit -m 125 -w ${PWD}/${ERA}_workspace.root --skip-prefit \
#         -d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
#         -o ${ERA}_datacard_shapes_postfit_sb.root -f fitDiagnostics${ERA}.root:fit_s |& tee postfitshapes_postfit.log

#     PostFitShapesFromWorkspace --postfit -m 125 -w ${PWD}/${ERA}_workspace.root --skip-prefit \
#         -d ${BASEDIR}/output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/${MASS}/combined.txt.cmb \
#         -o ${ERA}_datacard_shapes_postfit_b.root -f fitDiagnostics${ERA}.root:fit_b |& tee postfitshapes_postfit_bg_only.log

#     python /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/dev/utility/scripts/SystPlots/plotSyst.py \
#         -i ${ERA}_datacard_shapes_prefit.root -m $MASS -v $VAR -p png -s 0 -l 0

#     python /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/dev/utility/scripts/SystPlots/plotSyst.py \
#         -i ${ERA}_datacard_shapes_postfit_sb.root -m $MASS -v $VAR -p png -s 0 -l 0
# fi

combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS -d ${PWD}/${ERA}_workspace.root -n ".$ALGO.data" \
    --plots -v 3 |& tee gof_for_data.log

combineTool.py -M GoodnessOfFit --algo=${ALGO} -m $MASS --there -d ${PWD}/${ERA}_workspace.root \
    -n ".$ALGO.toys"  \
    -s ${SEEDS} -t $TOYS \
    --parallel ${NUM_THREADS} -v 0 |& tee gof_for_toys.log
    
combineTool.py -M CollectGoodnessOfFit \
    --input higgsCombine.${ALGO}.data.GoodnessOfFit.mH$MASS.root \
        higgsCombine.${ALGO}.toys.GoodnessOfFit.mH$MASS.*.root \
    --output gof.json |& tee collect.log				    

# Plot
plotGof.py --statistic ${ALGO} --mass $MASS.0 --output gof gof.json

# if [ ${ALGO} == saturated ]; then
#     /afs/cern.ch/work/m/msajatov/private/cms2/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/CombineToolset/MyCombineToolset/grepdata.sh
# fi

cd ${BASEDIR}
