#! /bin/bash

export BASE_PATH="/afs/hephy.at/work/m/msajatovic/cms/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/shapes"
export JETFAKES=true
export EMBEDDING=true
export CHANNELS="tt"
export STXS_SIGNALS=stxs_stage0
export CATEGORIES=gof
export GOF_CAT=tt_inclusive
export ERA=2017
export MASS=125
export TOYS=1
export NUM_THREADS=4


$CMSSW_BASE/bin/slc6_amd64_gcc530/MorphingSM2017 \
    --base_path=$BASE_PATH \
    --input_folder_mt="Test/bin_syst" \
    --input_folder_et="Test/bin_syst" \
    --input_folder_tt="Test/bin_syst" \
    --real_data=false \
    --jetfakes=$JETFAKES \
    --embedding=$EMBEDDING \
    --classic_bbb=false \
    --postfix="-m_vis" \
    --channel="$CHANNELS" \
    --auto_rebin=true \
    --stxs_signals=$STXS_SIGNALS \
    --categories=$CATEGORIES \
    --era=$ERA \
    --output="${ERA}_smhtt" \
    --gof_category_name=$GOF_CAT

cd output/${ERA}_smhtt/cmb/125/
for FILE in *.txt
do
    sed -i '$s/$/\n * autoMCStats 0.0/' $FILE
done
cd -

DATACARD_PATH=output/${ERA}_smhtt/cmb/125
NUM_THREADS=12
combineTool.py -M T2W -o ${ERA}_workspace.root -i ${DATACARD_PATH} --parallel $NUM_THREADS

cd ${DATACARD_PATH}

STATISTIC=saturated # or KS or AD

# Get test statistic value
# NOTE: --plots makes for KS and AD plots showing the bins with most tension.
# These plots can be found in the higgsCombine${NAME}.GoodnessOfFit.mH125.root
# file in the folder GoodnessOfFit.
combineTool.py -M GoodnessOfFit --algo=${STATISTIC} -m $MASS -d ${ERA}_workspace.root \
        -n ${ERA} \
        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 \
        --plots

# Throw toys
combineTool.py -M GoodnessOfFit --algo=${STATISTIC} -m $MASS -d ${ERA}_workspace.root \
        -n ${ERA} \
        -s 1230:1249:1 -t $TOYS \
        --parallel $NUM_THREADS \
        --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0

# Collect results
combineTool.py -M CollectGoodnessOfFit \
    --input higgsCombine${ERA}.GoodnessOfFit.mH$MASS.root \
        higgsCombine${ERA}.GoodnessOfFit.mH$MASS.*.root \
    --output gof.json

# Plot
plotGof.py --statistic ${STATISTIC} --mass $MASS.0 --output gof gof.json

