#!/bin/bash

O3D=$1
SUB=$2
OUT=$3

if [ -z $4 ]; then 
    VAR=dtidet
else
    VAR=$4
fi

ID_0001=FP
ID_0002=HT
ID_0003=KK
ID_0004=MP

ID_0005=105115
ID_0006=110411
ID_0007=111312
ID_0008=113619

ID_0009=108323
ID_0010=109123
ID_0011=111312
ID_0012=125525

ID=$(eval echo "\$ID_$SUB")

if [ $O3D ==  STN ]; then
    SRC=/N/dc2/projects/lifebid/2t1/predator/${ID}_96dirs_b2000_1p5iso/dtiInit
elif [ $O3D ==  HCP3T ]; then
    SRC=/N/dc2/projects/lifebid/2t1/HCP/${ID}/dt6_b2000trilin
elif [ $O3D ==  HCP7T ]; then
    SRC=/N/dc2/projects/lifebid/HCP7/${ID}/dt6/dti64trilin
fi

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

AFQ=${OUT}/O3D_${O3D}/derivatives/dissection_${VAR}_trk/sub-${SUB}/dwi
FE=${OUT}/O3D_${O3D}/derivatives/life_struct/sub-${SUB}/dwi
REF=${OUT}/O3D_${O3D}/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_dwi_brainmask.nii.gz
mkdir -p ${AFQ} 

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"
ADD3="addpath(genpath('/N/dc2/projects/lifebid/code/franpest/AFQ'))"

for N in 01 02 03 04 05 06 07 08 09 10; do
    TRK=${AFQ}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_var-afq
    MAT=${FE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_life.mat
    CMD="afqClean4life2trk $MAT $DT6 $REF $TRK"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${ADD3};${CMD};exit"
done

rm -r _temp${SUB}
exit

