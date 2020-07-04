#!/usr/bin/python

import argparse
import copy
import os
import subprocess
import time
import shutil

jobflavour = "workday"

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', dest='channel', help='Decay channel' ,required = True)
    parser.add_argument('-e', dest='era', help='Era',required = True )    
    parser.add_argument('--vars', dest='vars', nargs="*", help='Variable', default=[])
    parser.add_argument('--algos', dest='algos', nargs="*", help="Algorithm", default=["saturated", "KS", "AD"])
    parser.add_argument('--seeds', dest='seeds', help="Seeds", action="store_true")
    parser.add_argument('--patch', dest='patch', help='Patch')    
    
    args = parser.parse_args()    
    
    channel = args.channel
    era = args.era

    print "vars: {0}".format(args.vars)

    if not args.vars:
        variables = ["pt_1","pt_2","jpt_1","jpt_2","bpt_1","bpt_2","njets","nbtag","m_sv","mt_1",
                    "mt_2","pt_vis","pt_tt","mjj","jdeta","m_vis","dijetpt","met"]
#         variables = ["pt_1","pt_2"]
    else:
        variables = args.vars

    
    algos = args.algos
    print "algos: {0}".format(algos)

    subBaseFileName = "submit_gof_{0}_{1}.sub"
    timestamp = time.time()
    exeFileName = "{0}_gof_exe.sh".format(timestamp)
    
    createShFile(exeFileName, variables, algos, args.seeds, args.patch)
    
    subFileName = subBaseFileName.format(channel, era)
    createSubFile(subFileName, exeFileName, channel, era, variables)
    submit(subFileName, exeFileName, variables)

def submit(subFileName, exeFileName, vars):
    if not os.path.exists("temp"):
        os.makedirs("temp")
    shutil.move(subFileName, "temp/" + subFileName)
    shutil.move(exeFileName, "temp/" + exeFileName)
    os.chdir("temp")

    os.system("echo submitting {0}...".format(vars))
    
    cmd = "condor_submit {0}".format(subFileName)
    print cmd
    os.system(cmd)
    #time.sleep(1)

def createSubFile(subFileName, executableFileName, channel, era, vars):
    content = ""
    content = appendLine(content, "executable = {0}".format(executableFileName))
    content = appendLine(content, "arguments = {0} {1} {2}".format(channel, era, "$(ProcId)"))
    content = appendLine(content, "output                = gof.$(ClusterId).$(ProcId).out")
    content = appendLine(content, "error                 = gof.$(ClusterId).$(ProcId).err")
    content = appendLine(content, "log                   = gof.$(ClusterId).log")
    # content = appendLine(content, "getenv                = true")
    content = appendLine(content, '+JobFlavour = "{0}"'.format(jobflavour))
    #content = appendLine(content, "+BenchmarkJob = True")
    content = appendLine(content, "")
    content = appendLine(content, "# Send the job to Held state on failure.")
    content = appendLine(content, "on_exit_hold = (ExitBySignal == True) || (ExitCode != 0)")
    content = appendLine(content, "")
    content = appendLine(content, "# Periodically retry the jobs every 10 minutes, up to a maximum of 5 retries.")
    content = appendLine(content, "periodic_release =  (NumJobStarts < 3) && ((CurrentTime - EnteredCurrentStatus) > 600)")
    content = appendLine(content, "")
    content = appendLine(content, "queue {0}".format(len(vars)))
    
    writeToFile(subFileName, content)

def createShFile(executableFileName, vars, algos, seeds, patch):    
    # header = makeHeader()
    # content = copy.deepcopy(header)
    # #command = "python produce.py -c {1} -e {2} {3} --syst --fake_est nn --prefix {0}_ -o emb_dc/{0} |& tee emb_dc/{0}/{1}_{3}.log".format(mode, channel, era, var)
    # content = appendLine(content, "mkdir -p out")
    # content = appendLine(content, "mkdir -p out/$1")
    
    # for i, var in enumerate(vars):
    #     content = appendLine(content, "if [ $4 -eq {0} ]; then".format(i))
    #     command = "python produce.py -c $2 -e $3 {0} --syst -o out/$1 |& tee out/$1/$2_{0}.log".format(var)
    #     content = appendLine(content, command)
    #     content = appendLine(content, "fi")
        
    # print "content is"
    # print content
    # print ""
    
    # writeToFile(executableFileName, content)

    seed_list = ["1230:1249:1", "1250:1269:1", "1270:1289:1", "1290:1309:1", "1310:1329:1", 
                "1330:1349:1", "1350:1369:1", "1370:1389:1", "1390:1409:1", "1410:1429:1", 
                "1430:1449:1", "1450:1469:1", "1470:1489:1", "1490:1509:1", "1510:1529:1", 
                "1530:1549:1", "1550:1569:1", "1570:1589:1", "1590:1609:1", "1610:1629:1"]

    

    header = makeHeader()
    content = copy.deepcopy(header)
    
    for i, var in enumerate(vars):
        content = appendLine(content, "if [ $3 -eq {0} ]; then".format(i))
        for algo in algos:
            if seeds:
                seedstring = ""
                for seed in seed_list:
                    seedstring += seed + " "
                command = "time sh seed_wrapper.sh $1 $2 {0} {1} {2}".format(var, algo, seedstring)
            elif patch:
                command = "time sh run_patch{2}.sh $1 $2 {0} {1}".format(var, algo, patch)
            else:
                command = "time sh run_with_arguments.sh $1 $2 {0} {1}".format(var, algo)
        content = appendLine(content, command)
        content = appendLine(content, "fi")
        
    print "content is"
    print content
    print ""
    
    writeToFile(executableFileName, content)

    # run_with_arguments.sh et 2017 pt_1 saturated

def writeToFile(filename, content):
    f = open(filename, "w")
    f.write(content)
    f.close()

def makeHeader():
    content = ""
    content = appendLine(content, "#!/bin/sh")
    content = appendLine(content, "ulimit -s unlimited")
    content = appendLine(content, "#set -e")

    # add folder with run_with_arguments.sh to PATH
    dirname = "/afs/cern.ch/work/m/msajatov/private/cms3/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/CombineToolset/MyCombineToolset"
    content = appendLine(content, "export PATH={0}:$PATH".format(dirname))
    content = appendLine(content, "")

    # cd to dir where submit_gof.py was called (which is one dir above temp dir containing submit files)
    cwd = os.getcwd()
    content = appendLine(content, "cd {0}".format(cwd))
    content = appendLine(content, "") 


    # content = appendLine(content, "cd /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src")
    # content = appendLine(content, "export SCRAM_ARCH=slc6_amd64_gcc530")
    # content = appendLine(content, "eval `scramv1 runtime -sh`")
    # content = appendLine(content, "")
    # content = appendLine(content, "export PYTHONPATH=/afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/hh/HephyHiggs:$PYTHONPATH")
    # content = appendLine(content, "export PYTHONPATH=$HOME/.local/lib/python2.7/site-packages:$PYTHONPATH")

    
    # content = appendLine(content, "")
    # content = appendLine(content, "export EOS_MGM_URL=root://eosuser-fuse.cern.ch")
    # content = appendLine(content, "")
    # content = appendLine(content, "eos fuse mount /afs/cern.ch/work/m/msajatov/private/eosmount")
    # content = appendLine(content, "")
    # content = appendLine(content, "cd /afs/cern.ch/work/m/msajatov/private/CMSSW_9_4_0/src/hh/HephyHiggs/Tools/Datacard")
    # content = appendLine(content, "")    
    return content

def appendLine(text, new):
    text = text + new + "\n"
    return text
    
if __name__ == '__main__':
    main()