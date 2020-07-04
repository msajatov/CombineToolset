#! /bin/bash

VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 mt_2 pt_vis pt_tt mjj jdeta m_vis dijetpt met eta_1 eta_2"

SHORTVARS="m_sv met eta_1"


MASS=125
TOYS=25
NUM_THREADS=8
STATISTIC=saturated # or KS or AD


BASEDIR=${PWD}



# for each mode, navigate into correct directory and run submit there


