#! /bin/bash

SCRIPTDIR=`dirname $0`
. "$SCRIPTDIR/settings.sh" $1

rm -rf output

MorphingSM2017 \
--base_path="$BASEPATH" \
--verbose="$VERBOSITY" \
--input_folder_tt="$INPUTFOLDER" \
--channel="tt"  \
--real_data=true \
--postfix="$POSTFIX" \
--embedding=true \
--classic_bbb=false \
--auto_rebin=false \
--stxs_signals=stxs_stage0 \
--categories="$CATEGORIES" \
$GOFCATEGORYPARAMETER \
--era="$ERA" \
--output="${ERA}_smhtt" | tee MorphingSM2017.log

for ch in tt cmb
do
	cd output/${ERA}_smhtt/${ch}/125/
	for FILE in *.txt
	do
	    sed -i '$s/$/\n * autoMCStats 0.0/' $FILE
	done
	cd -
done
