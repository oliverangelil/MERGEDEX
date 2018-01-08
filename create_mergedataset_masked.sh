#!/bin/bash

###################################################
# PRPCPTOT
###################################################
# declare paths
path_data='/path_to_data/GHCNDEX-HadEX2'      
fname_H2='H2_PRCPTOT_1901-2010_RegularGrid_global_3.75x2.5deg_LSmask.nc'
fname_GHCND='GHCND_PRCPTOT_1951-2017_RegularGrid_global_2.5x2.5deg_LSmask_3.75x2.5deg.nc'

# declare period
yr1='1951'                                                        
yr2='2010'

# number of acceptable missing years for entire period
QC_all_years=$((($yr2-$yr1+1)*20/100)) #12 in this case

for obsname in H2 GHCND
do
    fname_var=fname_$obsname

    # trim files to years of interest
    cdo -s -selyear,$yr1/$yr2 $path_data/${!fname_var} $path_data/tmpf_${obsname}_PRCPTOT_1951-2010.nc

    # generate 3 masks based on whether: 1) at least 80% of data is non-missing in first 10 years; 2) at least 80% of data is non-missing in last 10 years; and 3) at least 80% of data is non-missing in entire period. 
    cdo -s -lec,2 -timsum -eqc,-999 -setmisstoc,-999 -selyear,$yr1/$(($yr1 + 9)) $path_data/tmpf_${obsname}_PRCPTOT_1951-2010.nc $path_data/tmpf_${obsname}_PRCPTOT_1951-2010_mask_first_10.nc
    cdo -s -lec,2 -timsum -eqc,-999 -setmisstoc,-999 -selyear,$yr1/$(($yr2 - 9)) $path_data/tmpf_${obsname}_PRCPTOT_1951-2010.nc $path_data/tmpf_${obsname}_PRCPTOT_1951-2010_mask_last_10.nc
    cdo -s -lec,$QC_all_years -timsum -eqc,-999 -setmisstoc,-999 $path_data/tmpf_${obsname}_PRCPTOT_1951-2010.nc $path_data/tmpf_${obsname}_PRCPTOT_1951-2010_mask_all.nc

    # multiply all masks together to end up with a final mask
    cdo -s -mul -mul $path_data/tmpf_${obsname}_PRCPTOT_1951-2010_mask_first_10.nc $path_data/tmpf_${obsname}_PRCPTOT_1951-2010_mask_last_10.nc  $path_data/tmpf_${obsname}_PRCPTOT_1951-2010_mask_all.nc  $path_data/tmpf_${obsname}_PRCPTOT_1951-2010_mask_final.nc
    
    # apply final mask to data
    cdo -s -div $path_data/tmpf_${obsname}_PRCPTOT_1951-2010.nc $path_data/tmpf_${obsname}_PRCPTOT_1951-2010_mask_final.nc $path_data/tmpf_${obsname}_PRCPTOT_1951-2010_QCmasked.nc
done

# merge GHCND and H2
cdo -s -ifthenelse -gtc,-999 -setmisstoc,-999 $path_data/tmpf_GHCND_PRCPTOT_1951-2010_QCmasked.nc $path_data/tmpf_GHCND_PRCPTOT_1951-2010_QCmasked.nc $path_data/tmpf_H2_PRCPTOT_1951-2010_QCmasked.nc $path_data/MERGEDEX_PRCPTOT_1951-2010_QCmasked.nc

# delete temporary files
rm $path_data/tmpf_*   

###################################################
# Rx1day
###################################################
# declare paths
fname_H2='H2_Rx1day_1901-2010_RegularGrid_global_3.75x2.5deg_LSmask.nc'
fname_GHCND='GHCND_Rx1day_1951-2017_RegularGrid_global_2.5x2.5deg_LSmask_3.75x2.5deg.nc'

for obsname in H2 GHCND
do
    fname_var=fname_$obsname

    # trim files to years 
    cdo -s -selyear,$yr1/$yr2 $path_data/${!fname_var} $path_data/tmpf_${obsname}_Rx1day_1951-2010.nc

    # generate 3 masks based on whether: 1) at least 80% of data is non-missing in first 10 years; 2) at least 80% of data is non-missing in last 10 years; and 3) at least 80% of data is non-missing in entire period. 
    cdo -s -lec,2 -timsum -eqc,-999 -setmisstoc,-999 -selyear,$yr1/$(($yr1 + 9)) $path_data/tmpf_${obsname}_Rx1day_1951-2010.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_first_10.nc
    cdo -s -lec,2 -timsum -eqc,-999 -setmisstoc,-999 -selyear,$yr1/$(($yr2 - 9)) $path_data/tmpf_${obsname}_Rx1day_1951-2010.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_last_10.nc
    cdo -s -lec,$QC_all_years -timsum -eqc,-999 -setmisstoc,-999 $path_data/tmpf_${obsname}_Rx1day_1951-2010.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_all.nc

    # multiply all masks together to end up with a final mask
    cdo -s -mul -mul $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_first_10.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_last_10.nc  $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_all.nc  $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_final.nc
    
    # apply final mask to data
    cdo -s -selvar,Ann -div $path_data/tmpf_${obsname}_Rx1day_1951-2010.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_final.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_QCmasked.nc

    rm $path_data/tmpf_${obsname}_Rx1day_1951-2010.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_first_10.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_last_10.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_all.nc $path_data/tmpf_${obsname}_Rx1day_1951-2010_mask_final.nc
done

# merge GHCND and H2
cdo -s -ifthenelse -gtc,-999 -setmisstoc,-999 $path_data/tmpf_GHCND_Rx1day_1951-2010_QCmasked.nc $path_data/tmpf_GHCND_Rx1day_1951-2010_QCmasked.nc $path_data/tmpf_H2_Rx1day_1951-2010_QCmasked.nc $path_data/MERGEDEX_Rx1day_1951-2010_QCmasked.nc

# delete temporary files
rm $path_data/tmpf_*   















