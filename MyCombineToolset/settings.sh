#! /bin/bash

SCRIPTDIR=`dirname $0`
if [ -e "$SCRIPTDIR/settings_$1.sh" ]; then
    source "$SCRIPTDIR/settings_$1.sh"
else
    echo "Please specify settings set as first parameter!"
    exit 1
fi
