#! /bin/bash

SCRIPTDIR=`dirname $0`
. "$SCRIPTDIR/settings.sh" $1


cd ${DATACARD_PATH}

# Get test statistic value
# NOTE: --plots makes for KS and AD plots showing the bins with most tension.
# These plots can be found in the higgsCombine${NAME}.GoodnessOfFit.mH125.root
# file in the folder GoodnessOfFit.
combineTool.py -M GoodnessOfFit --algo=${STATISTIC} -m $MASS -d ${ERA}_workspace.root \
        -n ${ERA} \
        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 \
        --plots | tee $OUTPUT_PATH/gof_for_data.log

cd -
