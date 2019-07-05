#! /bin/bash

SCRIPTDIR=`dirname $0`
. "$SCRIPTDIR/settings.sh" $1

combineTool.py -M T2W -o ${ERA}_workspace.root -i ${DATACARD_PATH} --parallel $NUM_THREADS | tee workspace.log
