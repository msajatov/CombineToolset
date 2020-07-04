#! /bin/sh

cd /afs/cern.ch/work/m/msajatov/private/cms3/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -

CHANNEL=$1
ERA=$2
VAR=$3
ALGO=$4

shift
shift
shift
shift

SEEDS=("$@")

BASEDIR=${PWD}

MASS=125
TOYS=25
# do NOT try to set this to anything else (CombineToolBase modified so it only expects one process)
# this was done to prevent strange issues with mp.Pool
NUM_THREADS=1


mkdir -p gof/aggregate/${ERA}/${VAR}/${ALGO}/${CHANNEL}	            
cp /afs/cern.ch/work/m/msajatov/private/cms3/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/CombineToolset/MyCombineToolset/aggregate.sh gof/aggregate/${ERA}/${VAR}/${ALGO}/${CHANNEL}




for SEED in "${SEEDS[@]}"; do
    cp -a gof/${SEED}/${ERA}/${VAR}/${ALGO}/${CHANNEL}/higgsCombine*.root gof/aggregate/${ERA}/${VAR}/${ALGO}/${CHANNEL}
done





cd gof/aggregate/${ERA}/${VAR}/${ALGO}/${CHANNEL}
    
combineTool.py -M CollectGoodnessOfFit \
    --input higgsCombine.${ALGO}.data.GoodnessOfFit.mH$MASS.root \
        higgsCombine.${ALGO}.toys.GoodnessOfFit.mH$MASS.*.root \
    --output gof.json |& tee collect.log				    

# Plot
plotGof.py --statistic ${ALGO} --mass $MASS.0 --output gof gof.json

cd ${BASEDIR}