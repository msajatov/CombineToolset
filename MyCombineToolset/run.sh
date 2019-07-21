#! /bin/bash

SCRIPTDIR=`dirname $0`
. "$SCRIPTDIR/settings.sh" $1

. "$SCRIPTDIR/make_datacards_for_gof.sh" $1
. "$SCRIPTDIR/t2w.sh" $1
. "$SCRIPTDIR/gof_for_data.sh" $1
. "$SCRIPTDIR/gof_for_toys.sh" $1
. "$SCRIPTDIR/collect.sh" $1
