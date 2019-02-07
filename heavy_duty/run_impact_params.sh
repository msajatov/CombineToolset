OUT=$1

eval `scramv1 runtime -sh`
cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017

mkdir -p Impacts/${OUT}
cd Impacts/${OUT}

combineTool.py -M T2W -o ${PWD}/workspace.root -i ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/cmb_smhtt/cmb/125

combineTool.py -M Impacts -m 125 -d ${PWD}/workspace.root --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --doInitialFit --robustFit 1 -v 1 --parallel 8 --rMin -5 --rMax 5 #--minimizerAlgoForMinos=Minuit2,Migrad
combineTool.py -M Impacts -m 125 -d ${PWD}/workspace.root --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --doFits --robustFit 1 --rMin -5 --rMax 5 --job-mode "condor" #--minimizerAlgoForMinos=Minuit2,Migrad
