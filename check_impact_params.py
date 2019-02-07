import ROOT as R
import sys
import os
from glob import glob

def getCorruptFiles():
	impact_dir = "/".join([ os.environ["CMSSW_BASE"], "src/CombineHarvester/HTTSM2017/Impacts", sys.argv[1] ])
	corrupt_files = []
	for param in glob( impact_dir + "/*paramFit*" ):
		error = 0
		if os.path.getsize(param) > 0:
			tmpfile = R.TFile(param)
			if not tmpfile.IsOpen() or tmpfile.IsZombie() or tmpfile.TestBit(R.TFile.kRecovered) or len(tmpfile.GetListOfKeys()) == 0:
				corrupt_files.append(param)
		else:
			corrupt_files.append(param)

	runLocal(impact_dir ,corrupt_files)


def runLocal(rundir, corrupt_files):
	cmd = "combine -M MultiDimFit -n _paramFit_Test_{0} --algo impact --redefineSignalPOIs r -P {0} --floatOtherPOIs 1 --saveInactivePOI 1 --X-rtd MINIMIZER_analytic --cminDefaultMinimizerStrategy 0 --robustFit 1 --rMin -5 --rMax 5 -m 125 -d workspace.root"
	os.chdir( rundir )
	for i in corrupt_files:
		param = i.split("paramFit_Test_")[1].split(".MultiDimFit.")[0]
		os.system( cmd.format(param)  )

if __name__ == '__main__':
	getCorruptFiles()