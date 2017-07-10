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

#
# Source files of DTIinit
#
if [ $O3D ==  STN ]; then
    SRC=/N/dc2/projects/lifebid/2t1/predator/${ID}_96dirs_b2000_1p5iso/dtiInit
elif [ $O3D ==  HCP3T ]; then
    SRC=/N/dc2/projects/lifebid/2t1/HCP/${ID}/dt6_b2000trilin
elif [ $O3D ==  HCP7T ]; then
    SRC=/N/dc2/projects/lifebid/HCP7/${ID}/dt6/dti64trilin
fi

#
# Create temp folder for DTIinit files
#
TMP=_temp${SUB}
mkdir -p ${TMP}/bin
F0=dt6.mat
F1=b0.nii.gz
F2=brainMask.nii.gz
F3=tensors.nii.gz
cp ${SRC}/${F0} ${TMP}/.
cp ${SRC}/bin/${F1} ${TMP}/bin/.
cp ${SRC}/bin/${F2} ${TMP}/bin/.
cp ${SRC}/bin/${F3} ${TMP}/bin/.
DT6=${TMP}/${F0}

#
# Setting input/output files
#
AFQ=${OUT}/derivatives/dissection_afq_${VAR}_trk/sub-${SUB}
FE=${OUT}/derivatives/life_struct/sub-${SUB}
REF=${OUT}/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_dwi_brainmask.nii.gz
mkdir -p ${AFQ} 

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"
ADD3="addpath(genpath('/N/dc2/projects/lifebid/code/franpest/AFQ'))"

#
# Iteration of dissection oover 10 repetition
#
for N in 01 02 03 04 05 06 07 08 09 10; do
    TRK=${AFQ}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_var-afq
    MAT=${FE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_life.mat
    CMD="afq4life2trk $MAT $DT6 $REF $TRK"
    #CMD="afqClean4life2trk $MAT $DT6 $REF $TRK"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${ADD3};${CMD};exit"
done

rm -r _temp${SUB}
exit

