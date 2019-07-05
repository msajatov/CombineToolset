#! /bin/bash

VERBOSITY="true"
BASEPATH="/afs/hephy.at/work/m/msajatovic/cms/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/shapes"
INPUTFOLDER="Test/bin_syst_cats"
POSTFIX="-m_vis"
CATEGORIES="gof"
AUTO_REBIN="false"

ERA=2017
MASS=125
TOYS=1
NUM_THREADS=4
STATISTIC=saturated # or KS or AD


if [ "$CATEGORIES" = "gof" ]; then
    GOFCATEGORYPARAMETER="--gof_category_name=tt_inclusive"
else
    GOFCATEGORYPARAMETER=""
fi

OUTPUT_PATH=$PWD
DATACARD_PATH=$OUTPUT_PATH/output/${ERA}_smhtt/cmb/$MASS


cd /afs/hephy.at/work/m/msajatovic/cms/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -
