
ERA=$1
CHANNEL=$2
VAR=$3

eval `scramv1 runtime -sh`
cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017

mkdir -p Plotting/${VAR}/${ERA}/${CHANNEL}
cd Plotting/${VAR}/${ERA}/${CHANNEL}

combineTool.py -M T2W -o ${PWD}/workspace.root -i ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/${VAR}/${ERA}_smhtt/${CHANNEL}/125
# # Prefit shapes
# # The text datacard is referenced only to add the original binning of the shapes
# # to the output histograms of the command. Otherwise, the bins are numbered with
# # integers.
PostFitShapesFromWorkspace -m 125 -w ${PWD}/workspace.root -d ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/${VAR}/${ERA}_smhtt/${CHANNEL}/125/combined.txt.cmb -o ${ERA}_datacard_shapes_prefit.root

# Postfit shapes
# The file fitDiagnostics${ERA}.root is the result of the FitDiagnostics shown
# combine -M FitDiagnostics -m 125 -d ${PWD}/workspace.root --robustFit 1 -n $ERA -v1 --robustHesse 1 --X-rtd MINIMIZER_analytic --X-rtd FITTER_NEW_CROSSING_ALGO --cminDefaultMinimizerStrategy 0 --rMin -2. --rMax 2
# PostFitShapesFromWorkspace --postfit -m 125 -w ${PWD}/workspace.root --skip-prefit -d ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/${VAR}/${ERA}_smhtt/${CHANNEL}/125/combined.txt.cmb -o ${ERA}_datacard_shapes_postfit_sb.root -f fitDiagnostics${ERA}.root:fit_s 