#! /bin/bash

cd /afs/cern.ch/work/m/msajatov/private/cms/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -

MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD
ALGO=saturated

combineTool.py -M CollectGoodnessOfFit \
				    --input higgsCombine.${ALGO}.data.GoodnessOfFit.mH$MASS.root \
				        higgsCombine.${ALGO}.toys.GoodnessOfFit.mH$MASS.*.root \
				    --output gof.json | tee collect.log
			
# Plot
plotGof.py --statistic ${ALGO} --mass $MASS.0 --output gof gof.json