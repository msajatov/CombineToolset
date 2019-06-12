
eval `scramv1 runtime -sh`
cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017

# rm -r output/*_smhtt


# MorphingSM2017 --input_folder_mt="Test/"  --input_folder_et="Test/"  --input_folder_tt="Test/syst_full_sig/"  --input_folder_em="KIT/"  --channel="tt" --real_data=true --postfix="-m_vis" --embedding=true --classic_bbb=false  --auto_rebin=true   --stxs_signals=stxs_stage0 --categories=gof  --gof_category_name=tt_inclusive  --era=2016  --output="2016_smhtt"
MorphingSM2017 --verbose="true"  --input_folder_mt="Test/nn_syst/4cat_bias_int/"  --input_folder_et="Test/nn_syst/4cat_bias_int/"  --input_folder_tt="Test/nn_syst/4cat_bias_int/"  --input_folder_em="KIT/"  --channel="tt"  --real_data=true --postfix="-m_vis" --embedding=true --classic_bbb=false  --auto_rebin=true   --stxs_signals=stxs_stage0 --categories=gof  --gof_category_name=tt_inclusive  --era=2017  --output="2017_smhtt"


# rm output/*_smhtt/*/125/*_em_*

# rm output/2016_smhtt/em/125/htt_*_??_*txt
# rm output/2017_smhtt/em/125/htt_*_??_*txt

# rm output/2016_smhtt/mt/125/htt_*_??_*txt
# rm output/2017_smhtt/mt/125/htt_*_??_*txt

# rm output/2016_smhtt/et/125/htt_*_??_*txt
# rm output/2017_smhtt/et/125/htt_*_??_*txt

# rm output/2016_smhtt/tt/125/htt_*_??_*txt
# rm output/2017_smhtt/tt/125/htt_*_??_*txt

for ch in et mt tt em cmb 
do
	cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/2016_smhtt/${ch}/125/
	pwd
	for FILE in *.txt
	do
	    sed -i '$s/$/\n * autoMCStats 0.0/' $FILE
	done
	cd -
	cd ${CMSSW_BASE}/src/CombineHarvester/HTTSM2017/output/2017_smhtt/${ch}/125/
	for FILE in *.txt
	do
	    sed -i '$s/$/\n * autoMCStats 0.0/' $FILE
	done
	cd -	
done 


# mkdir -p output/cmb_smhtt/cmb/125
# mkdir -p output/cmb_smhtt/cmb/common

# cp -v -p output/2016_smhtt/cmb/125/*txt  output/cmb_smhtt/cmb/125/
# cp -v -p output/2016_smhtt/cmb/common/*  output/cmb_smhtt/cmb/common/
# cp -v -p output/2017_smhtt/cmb/125/*txt  output/cmb_smhtt/cmb/125/
# cp -v -p output/2017_smhtt/cmb/common/*  output/cmb_smhtt/cmb/common/

# mkdir -p output/2016_signal_smhtt/cmb/125
# mkdir -p output/2016_signal_smhtt/cmb/common
# mkdir -p output/2017_signal_smhtt/cmb/125
# mkdir -p output/2017_signal_smhtt/cmb/common
# mkdir -p output/cmb_signal_smhtt/cmb/125
# mkdir -p output/cmb_signal_smhtt/cmb/common

# cp -v -p output/2016_smhtt/cmb/125/*txt  output/2016_signal_smhtt/cmb/125/
# cp -v -p output/2016_smhtt/cmb/common/*  output/2016_signal_smhtt/cmb/common/
# cp -v -p output/2017_smhtt/cmb/125/*txt  output/2017_signal_smhtt/cmb/125/
# cp -v -p output/2017_smhtt/cmb/common/*  output/2017_signal_smhtt/cmb/common/
# cp -v -p output/cmb_smhtt/cmb/125/*txt  output/cmb_signal_smhtt/cmb/125/
# cp -v -p output/cmb_smhtt/cmb/common/*  output/cmb_signal_smhtt/cmb/common/

# rm output/2016_signal_smhtt/cmb/125/htt_*_??_*txt
# rm output/2017_signal_smhtt/cmb/125/htt_*_??_*txt
# rm output/cmb_signal_smhtt/cmb/125/htt_*_??_*txt


