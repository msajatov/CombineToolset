import ROOT as R
import sys

R.gROOT.SetBatch(True)

f = R.TFile(sys.argv[1])
f.cd()

for dirkey in f.GetListOfKeys():
    dirname = dirkey.GetName()
    if dirname != "GoodnessOfFit": continue

    print("Process directory: {}".format(dirname))
    d = f.Get(dirname)
    d.cd()

    for histkey in d.GetListOfKeys():
        histname = histkey.GetName()
        if not "diff" in histname: continue

        h = d.Get(histname)
        cv = R.TCanvas(histname, histname, 10, 10, 800, 600)
        cv.cd()
        h.Draw()
        cv.SaveAs(sys.argv[1].split("/")[-1].replace(".root",".png") )