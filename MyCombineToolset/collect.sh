#! /bin/bash

SCRIPTDIR=`dirname $0`
. "$SCRIPTDIR/settings.sh" $1

cd ${DATACARD_PATH}

combineTool.py -M CollectGoodnessOfFit \
    --input higgsCombine${ERA}.GoodnessOfFit.mH$MASS.root \
        higgsCombine${ERA}.GoodnessOfFit.mH$MASS.*.root \
    --output gof.json | tee $OUTPUT_PATH/collect.log

  # Plot
  plotGof.py --statistic ${STATISTIC} --mass $MASS.0 --output gof gof.json | tee $OUTPUT_PATH/plot.log
