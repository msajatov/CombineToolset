OUT=$1

eval `scramv1 runtime -sh`
cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017

mkdir -p Impacts/${OUT}
cd Impacts/${OUT}

combineTool.py -M Impacts -m 125 -d ${PWD}/workspace.root --output impacts.json
plotImpacts.py -i impacts.json -o impacts