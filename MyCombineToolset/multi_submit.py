#!/usr/bin/python

import argparse
import copy
import os
import subprocess
import time
import shutil

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', dest='channel', help='Decay channel' ,required = True)
    parser.add_argument('-e', dest='era', help='Era',required = True )    
    parser.add_argument('--vars', dest='vars', nargs="*", help='Variable', default=[])
    parser.add_argument('--algos', dest='algos', nargs="*", help="Algorithm", default=["saturated", "KS", "AD"])
    parser.add_argument('--seeds', dest='seeds', help="Seeds", action="store_true")
    parser.add_argument('--patch', dest='patch', help='Patch') 
    parser.add_argument('--conf', dest='configs', nargs="*", help="Configurations", default=[])
    
    args = parser.parse_args()    

    for conf in args.configs:
        pwd = os.getcwd()
        os.chdir(conf)

        seeds_flag = ""
        if args.seeds:
            seeds_flag = "--seeds"

        varstring = ""
        for v in args.vars:
            varstring += v + " "

        varstring = varstring.rstrip()

        algostring = ""
        for algo in args.algos:
            algostring += algo + " "

        algostring = algostring.rstrip()

        if args.patch:
            if not args.vars:
                cmd = "submit_gof.py -c {0} -e {1} --algos {3} --patch {5} {4}".format(args.channel, args.era, varstring, algostring, seeds_flag, args.patch)
            elif not args.algos:
                cmd = "submit_gof.py -c {0} -e {1} --vars {2} --patch {5} {4}".format(args.channel, args.era, varstring, algostring, seeds_flag, args.patch)
            else:
                cmd = "submit_gof.py -c {0} -e {1} --vars {2} --algos {3} --patch {5} {4}".format(args.channel, args.era, varstring, algostring, seeds_flag, args.patch)
        else:        
            if not args.vars:
                cmd = "submit_gof.py -c {0} -e {1} --algos {3} {4}".format(args.channel, args.era, varstring, algostring, seeds_flag)
            elif not args.algos:
                cmd = "submit_gof.py -c {0} -e {1} --vars {2} {4}".format(args.channel, args.era, varstring, algostring, seeds_flag)
            else:
                cmd = "submit_gof.py -c {0} -e {1} --vars {2} --algos {3} {4}".format(args.channel, args.era, varstring, algostring, seeds_flag)
        
        print cmd
        os.system(cmd)

        os.chdir(pwd)

if __name__ == '__main__':
    main()