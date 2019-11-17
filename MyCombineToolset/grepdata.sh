#! /bin/bash

echo "gof_for_data.log:"

#grep "Minuit2Minimizer :" gof_for_data.log | tee grepoutput.log
grep "FVAL  =" gof_for_data.log | tee grepoutput.log
grep "Edm   =" gof_for_data.log | tee -a grepoutput.log
grep "Nfcn  =" gof_for_data.log | tee -a grepoutput.log

#grep "r[[:space:]]+" gof_for_data.log | tee grepoutput.log

echo "-----------------------------------------------------"
echo "postfitshapes_fit.log:"

grep "RooFitResult: minimized FCN value:" postfitshapes_fit.log | tee -a grepoutput.log
grep "covariance matrix quality:" postfitshapes_fit.log | tee -a grepoutput.log
grep "Status : MINIMIZE" postfitshapes_fit.log | tee -a grepoutput.log
grep "Best fit r:" postfitshapes_fit.log | tee -a grepoutput.log


echo "-----------------------------------------------------"
echo "gof.json:"

head gof.json | tee -a grepoutput.log
