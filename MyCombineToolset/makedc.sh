#! /bin/bash

cd /afs/cern.ch/work/m/msajatov/private/cms3/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -

rm -rf output

BASEPATH="/afs/cern.ch/work/m/msajatov/private/cms3/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/shapes"
INPUTFOLDER="emb_dc/$1"

MASS=125

VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 mt_2 pt_vis pt_tt mjj jdeta m_vis dijetpt met eta_1 eta_2"

SHORTVARS="m_sv"



for ERA in 2017 ; do    
	for VAR in ${VARS} ; do	
		  
		
		    
	    for CHANNEL in et mt tt; do
	    
	    	mkdir -p output/${ERA}_smhtt/${VAR}/${CHANNEL}
	    
		    MorphingSM2017 \
			--base_path="$BASEPATH" \
			--verbose="true" \
			--input_folder_${CHANNEL}="$INPUTFOLDER" \
			--channel="$CHANNEL"  \
			--real_data=true \
			--postfix="-${VAR}" \
			--embedding=true \
			--classic_bbb=false \
			--auto_rebin=false \
			--stxs_signals=stxs_stage0 \
			--categories="gof" \
			--gof_category_name=${CHANNEL}_inclusive \
			--era="$ERA" \
			--output="${ERA}_smhtt/${VAR}/${CHANNEL}" |& tee MorphingSM2017_${CHANNEL}_${VAR}.log
	    
			cd output/${ERA}_smhtt/${VAR}/${CHANNEL}/${CHANNEL}/125/
			for FILE in *.txt ; do
				sed -i '$s/$/\n * autoMCStats 0.0/' $FILE
			done
			cd -	
			
			cd output/${ERA}_smhtt/${VAR}/${CHANNEL}/cmb/125/
			for FILE in *.txt ; do
				sed -i '$s/$/\n * autoMCStats 0.0/' $FILE
			done
			cd -	
		done 
		
		
		
	done
done

