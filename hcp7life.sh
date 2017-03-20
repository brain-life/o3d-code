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

if [ $2 = 'dtidet' ]; then
    LAB1='wm_tensor'
    LAB2='tensor_'
elif [ $2 = 'csddet' ]; then
    LAB1='csd_lmax8_wm_SD_STREAM'
    LAB2='SD_STREAM_lmax8'
elif [ $2 = 'csdprob' ]; then
    LAB1='csd_lmax8_wm_SD_PROB'
    LAB2='SD_PROB_lmax8'
else
    echo 'Wrong type of tractography'; exit
fi

DIR=/N/dc2/projects/lifebid/Paolo/data/O3D_SRC/HCP7T/${ID}
SRC=/N/dc2/projects/o3d/test3/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/dwi

DWI=${SRC}/sub-${SUB}_b-2000_dwi.nii.gz
OUT=${DIR}/fe_structure_${ID}_STC_run01_${LAB2}_connNUM
ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/lifebid/Paolo/code/multishell-mrtrix'))"

for N in 01 02 03 04 05 06 07 08 09 10; do
    TCK=${DIR}/data_b2000_${LAB1}-NUM${N}-500000.tck
    MAT=${OUT}${N}.mat
    CMD="life_eval_multishell $TCK $DWI $MAT"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
done

