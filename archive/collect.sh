export ERA=2017
export MASS=125

combineTool.py -M CollectGoodnessOfFit \
    --input higgsCombine${ERA}.GoodnessOfFit.mH$MASS.root \
        higgsCombine${ERA}.GoodnessOfFit.mH$MASS.*.root \
    --output gof.json

