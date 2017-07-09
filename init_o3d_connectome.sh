#!/bin/bash

SUB=$1
OUT=$2

if [ -z $3 ]; then 
    VAR=dtidet
else
    VAR=$3
fi

ID_0001=FP
ID_0002=HT
ID_0003=KK
ID_0004=MP

ID_0005=105115
ID_0006=110411
ID_0007=111312
ID_0008=113619

ID_0009=7t_102311
ID_0010=7t_109123
ID_0011=7t_111312
ID_0012=7t_125525

O3D_0001=STN
O3D_0002=STN
O3D_0003=STN
O3D_0004=STN

O3D_0005=HCP3T
O3D_0006=HCP3T
O3D_0007=HCP3T
O3D_0008=HCP3T

O3D_0009=HCP7T
O3D_0010=HCP7T
O3D_0011=HCP7T
O3D_0012=HCP7T

ID=$(eval echo "\$ID_$SUB")
O3D=$(eval echo "\$O3D_$SUB")

SRC=/N/dc2/projects/lifebid/lifeconn/subjects

if [ $VAR ==  dtidet ]; then
    FN=${SRC}/${ID}/o3d/fn_${ID}_aparc+aseg_tensor__rep
elif [ $VAR ==  csddet ]; then
    FN=${SRC}/${ID}/o3d/fn_${ID}_aparc+aseg_SD_STREAM_lmax8_rep
elif [ $VAR ==  csdprob ]; then
    FN=${SRC}/${ID}/o3d/fn_${ID}_aparc+aseg_SD_PROB_lmax8_rep
fi

DIR=${OUT}/derivatives/connectome_tract/sub-${SUB}
mkdir -p ${DIR} 

for N in 01 02 03 04 05 06 07 08 09 10; do
    CSV=${DIR}/sub-${SUB}_dwi_var-${VAR}life_run-${N}
    MAT=${FN}${N}.mat
    CMD=/N/dc2/projects/o3d/code/utils/o3d_bids_init_connectome_mat2csv.py
    python $CMD $MAT $CSV
done

exit
