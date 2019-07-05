#! /bin/bash

cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017

export ERA=2017
export MASS=125
export TOYS=1
export NUM_THREADS=4

DATACARD_PATH=output/${ERA}_smhtt/cmb/125
#NUM_THREADS=4
#combineTool.py -M T2W -o ${ERA}_workspace.root -i ${DATACARD_PATH} --parallel $NUM_THREADS

cd ${DATACARD_PATH}

STATISTIC=saturated # or KS or AD

# Get test statistic value
# NOTE: --plots makes for KS and AD plots showing the bins with most tension.
# These plots can be found in the higgsCombine${NAME}.GoodnessOfFit.mH125.root
# file in the folder GoodnessOfFit.
#combineTool.py -M GoodnessOfFit --algo=${STATISTIC} -m $MASS -d ${ERA}_workspace.root \
#        -n ${ERA} \
#        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 \
#        --plots

# Throw toys
 combineTool.py -M GoodnessOfFit --algo=${STATISTIC} -m $MASS -d ${ERA}_workspace.root \
         -n ${ERA} \
         -s 1230:1249:1 -t $TOYS \
         --parallel $NUM_THREADS \
         --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0

# Collect results
#combineTool.py -M CollectGoodnessOfFit \
#    --input higgsCombine${ERA}.GoodnessOfFit.mH$MASS.root \
#        higgsCombine${ERA}.GoodnessOfFit.mH$MASS.*.root \
#    --output gof.json

# Plot
#plotGof.py --statistic ${STATISTIC} --mass $MASS.0 --output gof gof.json

