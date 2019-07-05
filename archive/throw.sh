BIN=2
OUT=$1


eval `scramv1 runtime -sh`
cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017

for ERA in 2017 ; do
    for CHANNEL in tt ; do
        for ALGO in saturated ; do

            mkdir -p GOF/${OUT}/${ERA}/${ALGO}/${CHANNEL}
            cd GOF/${OUT}/${ERA}/${ALGO}/${CHANNEL}

            combineTool.py -M T2W -o ${PWD}/workspace.root -i ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/${ERA}_smhtt/${CHANNEL}/125

            # Throw toys
            combineTool.py -M GoodnessOfFit --algorithm $ALGO -m 125 --there -d ${PWD}/workspace.root -n ".$ALGO.toys" -t 1 -s 1220:1269:1 --verbose 0 --rMin -5 --rMax 5 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0
            cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017
        done
    done
done

for ERA in 2017 ; do
    mkdir -p GOF/${OUT}/${ERA}/saturated/cmb_signal
    cd GOF/${OUT}/${ERA}/saturated/cmb_signal

    combineTool.py -M T2W -o ${PWD}/workspace.root -i ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/${ERA}_signal_smhtt/cmb/125
    combineTool.py -M GoodnessOfFit --algorithm saturated -m 125 --there -d ${PWD}/workspace.root -n ".saturated.toys" -t 1 -s 1220:1299:1 --verbose 0 --rMin -5 --rMax 5 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0

    cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017


done

mkdir -p GOF/${OUT}/saturated/cmb_signal
cd GOF/${OUT}/saturated/cmb_signal

combineTool.py -M T2W -o ${PWD}/workspace.root -i ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/cmb_signal_smhtt/cmb/125
combineTool.py -M GoodnessOfFit --algorithm saturated -m 125 --there -d ${PWD}/workspace.root -n ".saturated.toys" -t 1 -s 1220:1299:1 --verbose 0 --rMin -5 --rMax 5 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0

cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017


