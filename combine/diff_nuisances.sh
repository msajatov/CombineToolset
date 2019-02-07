OUT=$1

eval `scramv1 runtime -sh`
cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017

mkdir -p diffNuisances/${OUT}
cd diffNuisances/${OUT}

combineTool.py -M T2W -o ${PWD}/workspace.root -i ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/cmb_smhtt/cmb/125
combine -M FitDiagnostics -m 125 -d ${PWD}/workspace.root --robustFit 1 -n CMB -v 1 --X-rtd FITTER_NEW_CROSSING_ALGO --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --rMin -10. --rMax 10

root -l fitDiagnosticsCMB.root <<< "fit_b->Print(); fit_s->Print()" | grep "covariance matrix quality"
python $CMSSW_BASE/src/HiggsAnalysis/CombinedLimit/test/diffNuisances.py -a -f html fitDiagnosticsCMB.root > diff_nuisances.html
