#! /bin/bash

SCRIPTDIR=`dirname $0`
. "$SCRIPTDIR/settings.sh" $1

cd ${DATACARD_PATH}

# Throw toys
combineTool.py -M GoodnessOfFit --algo=${STATISTIC} -m $MASS -d ${ERA}_workspace.root \
         -n ${ERA} \
         -s 1230:1249:1 -t $TOYS \
         --parallel $NUM_THREADS \
         --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 | tee $OUTPUT_PATH/gof_for_toys.log
