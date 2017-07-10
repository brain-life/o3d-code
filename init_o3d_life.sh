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

ID_0009=102311_Paolo_masks
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
    TRK=_tensor__
elif [ $VAR ==  csddet ]; then
    TRK=_SD_STREAM_lmax8_
elif [ $VAR ==  csdprob ]; then
    TRK=_SD_PROB_lmax8_
fi

if [ $O3D == HCP7T ]; then
    SRC=${SRC}/7t_${ID}
fi

mkdir -p ${OUT}/derivatives/life_struct/sub-${SUB}

for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${SRC}/fe_structure_${ID}_STC_run01${TRK}connNUM${N}.mat \
	${OUT}/derivatives/life_struct/sub-${SUB}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_life.mat
done


exit