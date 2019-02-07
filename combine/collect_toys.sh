BIN=2
OUT=$1


eval `scramv1 runtime -sh`
cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017

for ERA in 2016 2017 ; do
    for CHANNEL in em ; do
        for ALGO in saturated KS AD ; do

            cd GOF/${OUT}/${ERA}/${ALGO}/${CHANNEL}

            # Get test statistic
            combineTool.py -M GoodnessOfFit --algorithm ${ALGO} -m 125 --there -d ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/GOF/${OUT}/${ERA}/${ALGO}/${CHANNEL}/workspace.root -n ".$ALGO" --plots --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 

            # Collect results
            combineTool.py -M CollectGoodnessOfFit --input higgsCombine.${ALGO}.GoodnessOfFit.mH125.root higgsCombine.${ALGO}.toys.GoodnessOfFit.mH125.*.root -o ${CHANNEL}_${ERA}_${OUT}.${ALGO}.json

            # Plot
            plotGof.py --statistic ${ALGO} --mass 125.0 --output ${CHANNEL}_${ERA}_${OUT}.${ALGO} ${CHANNEL}_${ERA}_${OUT}.${ALGO}.json

            mv higgsCombine.${ALGO}.GoodnessOfFit.mH125.root teststatistic.${ERA}.${CHANNEL}.${ALGO}.${OUT}.root 
            python ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/toolset/get_teststatistic.py teststatistic.${ERA}.${CHANNEL}.${ALGO}.${OUT}.root
            cp *png ../
           

            cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017
        done
    done
done

# for ERA in 2016 2017 ; do

#     cd GOF/${OUT}/${ERA}/saturated/cmb_signal

#     combineTool.py -M GoodnessOfFit --algorithm saturated -m 125 --there -d ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/GOF/${OUT}/${ERA}/saturated/cmb_signal/workspace.root -n ".saturated" --plots --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 
#     combineTool.py -M CollectGoodnessOfFit --input higgsCombine.saturated.GoodnessOfFit.mH125.root higgsCombine.saturated.toys.GoodnessOfFit.mH125.*.root -o cmb_signal_${ERA}_${BIN}.saturated.json
#     plotGof.py --statistic saturated --mass 125.0 --output cmb_signal_${ERA}_${BIN}.saturated cmb_signal_${ERA}_${BIN}.saturated.json

#     cp *png ../
#     cp higgsCombine.saturated.GoodnessOfFit.mH125.root ../higgsCombine.cmb_signal.saturated.GoodnessOfFit.mH125.root

#     cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017


# done


# cd GOF/${OUT}/saturated/cmb_signal

# combineTool.py -M GoodnessOfFit --algorithm saturated -m 125 --there -d ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/GOF/${OUT}/saturated/cmb_signal/workspace.root -n ".saturated" --plots --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 
# combineTool.py -M CollectGoodnessOfFit --input higgsCombine.saturated.GoodnessOfFit.mH125.root higgsCombine.saturated.toys.GoodnessOfFit.mH125.*.root -o cmb_signal_${BIN}.saturated.json
# plotGof.py --statistic saturated --mass 125.0 --output cmb_signal_${BIN}.saturated cmb_signal_${BIN}.saturated.json

# cp *png ../
# cp higgsCombine.saturated.GoodnessOfFit.mH125.root ../higgsCombine.saturated.GoodnessOfFit.mH125.root

# cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017


