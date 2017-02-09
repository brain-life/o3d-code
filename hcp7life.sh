#!/bin/bash

#PBS -k o 
#PBS -l nodes=1:ppn=2,mem=32000mb,walltime=96:00:00 
#PBS -M pavesani@iu.edu
#PBS -m abe
#PBS -N hcp7t-life
#PBS -j oe

ID_0009=108323
ID_0010=109123
ID_0011=131217
ID_0012=910241

SUB=$1
ID=$(eval echo "\$ID_$1")

if [ $2 = 'dtidet']; then
    LAB='tensor_'
elif [ $2 = 'csddet' ]; then
    LAB='SD_STREAM_lmax8'
elif [ $2 = 'csdprob' ]; then
    LAB='SD_PROB_lmax8'
else
    echo 'Wrong type of tractography'; exit
fi

DIR=/N/dc2/projects/lifebid/Paolo/data/O3D_SRC/HCP7T/${ID}
SRC=/N/dc2/projects/o3d/test3/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/dwi

TCK=${DIR}/data_b2000_wm_tensor-NUM01-500000.tck
DWI=${SRC}/sub-${SUB}_b-2000_dwi.nii.gz
OUT=${DIR}/fe_structure_${ID}_STC_run01_${LAB}_connNUM

for N in 01 02 03 04 05 06 07 08 09 10; do
    MAT=${OUT}${N}.mat
    CMD="life_eval_multishell $TCK $DWI $MAT"
    matlab -nojvm -nodesktop -nosplash -r "${CMD};exit"
done

