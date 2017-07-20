#!/bin/bash

SUB=$1

#if [ -z $2 ]; then 
#    VAR=dtidet
#else
#    VAR=$2
#fi

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

ID=$(eval echo "\$ID_$SUB")
ALL_VAR='dtidet csddet csdprob'
ALL_NUM='01 02 03 04 05 06 07 08 09 10'

DIR=/N/dc2/projects/lifebid/HCP7
SRC=/N/dc2/projects/o3d/data/derivatives
OUT=/N/dc2/projects/o3d/HCP7/${ID}

mkdir -p ${OUT}/connectome

if [ ! -f ${OUT}/${ID}_acpc2dwi_affine.mat ]; then
    echo 'Computing affine acpc to dwi...'
    flirt -in ${DIR}/${ID}/anatomy/freesurfer/mri/aparc+aseg.nii.gz \
	-ref ${OUT}/dti64trilin/bin/b0.nii.gz \
	-omat ${OUT}/${ID}_acpc2dwi_affine.mat 
fi
    
if [ ! -f ${OUT}/${ID}_dwi_aparc+aseg.nii.gz ]; then
    echo 'Computing the registration of aparc+aseg to dwi..'
    flirt -in ${DIR}/${ID}/anatomy/freesurfer/mri/aparc+aseg.nii.gz \
	-ref ${OUT}/dti64trilin/bin/b0.nii.gz \
	-applyxfm -init ${OUT}/${ID}_acpc2dwi_affine.mat \
	-out ${OUT}/${ID}_dwi_aparc+aseg.nii.gz
fi

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"

for VAR in $ALL_VAR; do
    for N in $ALL_NUM; do
	echo Computing connectome for $VAR \(iteration ${N}\)
	FE=${OUT}/${ID}_${VAR}_run-${N}_life.mat
	LAB=${OUT}/${ID}_dwi_aparc+aseg.nii.gz
	CSV1=${OUT}/connectome/${ID}_${VAR}_run-${N}_fcount_connectome.csv
	CSV2=${OUT}/connectome/${ID}_${VAR}_run-${N}_fdensity_connectome.csv
	CMD="initConnectome $FE $LAB $CSV1 $CSV2"
	matlab -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
    done
done

exit
