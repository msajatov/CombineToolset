#! /bin/bash

cd /afs/hephy.at/work/m/msajatovic/cms/CMSSW_8_1_0/src
eval `scramv1 runtime -sh`
cd -

rm -rf output

BASEPATH="/afs/hephy.at/work/m/msajatovic/cms/CMSSW_8_1_0/src/CombineHarvester/HTTSM2017/shapes"
INPUTFOLDER="syst/cc/dc"

MASS=125

VARS="pt_1 pt_2 jpt_1 jpt_2 bpt_1 bpt_2 njets nbtag m_sv mt_1 pt_tt mjj jdeta m_vis dijetpt met eta_1 eta_2"

SHORTVARS="pt_1 pt_2"



for ERA in 2017 ; do    
	for VAR in ${SHORTVARS} ; do	
		  
		
		    
	    for CHANNEL in tt ; do
	    
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
			--output="${ERA}_smhtt/${VAR}/${CHANNEL}" | tee MorphingSM2017.log
	    
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

