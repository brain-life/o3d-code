#!/bin/bash

SUB=$1
OUT=$2

if [ -z $3 ]; then 
    VAR=dtidet
else
    VAR=$3
fi

ID_0001=FP_96dirs_b2000_1p5iso
ID_0002=HT_96dirs_b2000_1p5iso
ID_0003=KK_96dirs_b2000_1p5iso
ID_0004=MP_96dirs_b2000_1p5iso

ID_0005=105115
ID_0006=110411
ID_0007=111312
ID_0008=113619

ID_0009=102311
ID_0010=109123
ID_0011=111312
ID_0012=125525

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

SRC=/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/Revision_Feb2017/Results/Single_TC/fe_structures

if [ $VAR ==  dtidet ]; then
    FE=$SRC/fe_structure_${ID}_STC_run01_500000_tensor__connNUM
elif [ $VAR ==  csddet ]; then
    FE=$SRC/fe_structure_${ID}_STC_run01_500000_SD_STREAM_lmax8_connNUM
elif [ $VAR ==  csdprob ]; then
    FE=$SRC/fe_structure_${ID}_STC_run01_500000_SD_PROB_lmax8_connNUM
fi

AFQ=${OUT}/O3D_${O3D}/derivatives/dissection_afq_${VAR}_trk/sub-${SUB}/dwi
REF=${OUT}/O3D_${O3D}/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_dwi_brainmask.nii.gz
mkdir -p ${AFQ} 

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"

for N in 01 02 03 04 05 06 07 08 09 10; do
    TRK=${AFQ}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_var-afq
    MAT=${FE}${N}_TRACTS.mat
    CMD="afq2trk $MAT $REF $TRK"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
done

exit
