#!/bin/bash

SUB=$1
OUT=$2

ID_0009=108323
ID_0010=109123
ID_0011=111312
ID_0012=125525

ID=$(eval echo "\$ID_$SUB")

SRC=/N/dc2/projects/lifebid/HCP7




### PREPROCESS ANAT

#cp ${SRC}/${ID}/anatomy/T1w_acpc_dc_restore_1.05.nii.gz \
#    ${OUT}/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/anat/sub-${SUB}_T1w.nii.gz    

### PREPROCESS DWI

DWI=data_b2000_aligned_trilin_noMEC

mkdir -p ${OUT}/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/dwi

cp ${SRC}/${ID}/dt6/${DWI}.nii.gz \
    ${OUT}/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi.nii.gz
cp ${SRC}/${ID}/dt6/${DWI}.bvals \
    ${OUT}/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi.bvals
cp ${SRC}/${ID}/dt6/${DWI}.bvecs \
    ${OUT}/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi.bvecs
cp ${SRC}/${ID}/dt6/dti64trilin/bin/brainMask.nii.gz \
    ${OUT}/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_dwi_brainmask.nii.gz


### RECON MODELS

mkdir -p ${OUT}/O3D_HCP7T/derivatives/recon_models/sub-${SUB}/anat

cp ${SRC}/${ID}/dt6/dti64trilin/bin/wmMask.nii.gz \
    ${OUT}/O3D_HCP7T/derivatives/recon_models/sub-${SUB}/anat/sub-${SUB}_T1_wmmask.nii.gz

mkdir -p ${OUT}/O3D_HCP7T/derivatives/recon_models/sub-${SUB}/dwi

mrconvert ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_dt.mif \
    ${OUT}/O3D_HCP7T/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_DTI.nii.gz
mrconvert ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_ev.mif \
    ${OUT}/O3D_HCP7T/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_EV.nii.gz
mrconvert ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_fa.mif \
    ${OUT}/O3D_HCP7T/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_FA.nii.gz
mrconvert ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_lmax8.mif \
    ${OUT}/O3D_HCP7T/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_ODF.nii.gz
cp ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_response.txt \
    ${OUT}/O3D_HCP7T/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_dwiresponse.txt


### TRACTOGRAPHY

TCK=data_b2000_aligned_trilin_noMEC

mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_dtidet_tck
for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${SRC}/${ID}/tractography/${TCK}_wm_tensor-NUM${N}-500000.tck \
	${OUT}/O3D_HCP7T/derivatives/tracking_dtidet_tck/sub-${SUB}/dwi/sub-${SUB}_dwi_var-dtidet_run-${N}_tract.tck
done

mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_csddet_tck
for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${SRC}/${ID}/tractography/${TCK}_csd_lmax8_wm_SD_STREAM-NUM${N}-500000.tck \
	${OUT}/O3D_HCP7T/derivatives/tracking_csddet_tck/sub-${SUB}/dwi/sub-${SUB}_dwi_var-csddet_run-${N}_tract.tck
done

mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_csdprob_tck
for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${SRC}/${ID}/tractography/${TCK}_csd_lmax8_wm_SD_PROB-NUM${N}-500000.tck \
	${OUT}/O3D_HCP7T/derivatives/tracking_csdprob_tck/sub-${SUB}/dwi/sub-${SUB}_dwi_var-csdprob_run-${N}_tract.tck
done


REF=${OUT}/O3D_HCP7T/preprocess/sub-${SUB}/dwi/sub-${SUB}_dwi_brainmask.ni.gz

mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_dtidet_trk
TCK=${OUT}/O3D_HCP7T/derivatives/tracking_dtidet_tck/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_dtidet_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TCK}/sub-${SUB}_dwi_var-dtidet_run-${N}_tract.tck \
	-o ${TRK}/sub-${SUB}_dwi_var-dtidet_run-${N}_tract.trk \
	-a ${REF}
done

mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_csddet_trk
TCK=${OUT}/O3D_HCP7T/derivatives/tracking_csddet_tck/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_csddet_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TCK}/sub-${SUB}_dwi_var-csddet_run-${N}_tract.tck \
	-o ${TRK}/sub-${SUB}_dwi_var-csddet_run-${N}_tract.trk \
	-a ${REF}
done

mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_csdprob_trk
TCK=${OUT}/O3D_HCP7T/derivatives/tracking_csdprob_tck/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_csdprob_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TCK}/sub-${SUB}_dwi_var-csdprob_run-${N}_tract.tck \
	-o ${TRK}/sub-${SUB}_dwi_var-csdprob_run-${N}_tract.trk \
	-a ${REF}
done


### LIFE STRUCT

FE=/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/Revision_Feb2017/Results/Single_TC/fe_structures

mkdir -p ${OUT}/O3D_HCP7T/derivatives/life_struct

for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${FE}/7t_${ID}/fe_structure_${ID}_STC_run01_tensor__connNUM${N}.mat \
	${OUT}/O3D_HCP7T/derivatives/life_struct/sub-${SUB}/dwi/sub-${SUB}_dwi_var-dtidetlife_run-${N}_life.mat
done

for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${FE}/7t_${ID}/fe_structure_${ID}_STC_run01_SD_STREAM_lmax8_connNUM${N}.mat \
	${OUT}/O3D_HCP7T/derivatives/life_struct/sub-${SUB}/dwi/sub-${SUB}_dwi_var-csddetlife_run-${N}_life.mat
done

for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${FE}/7t_${ID}/fe_structure_${ID}_STC_run01_SD_PROB_lmax8_connNUM${N}.mat \
	${OUT}/O3D_HCP7T/derivatives/life_struct/sub-${SUB}/dwi/sub-${SUB}_dwi_var-csdproblife_run-${N}_life.mat
done


### LIFE TRACTOGRAPHY

FE=${OUT}/O3D_HCP7T/derivatives/life_struct/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"

VAR=dtidet
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    MAT=${FE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_life.mat
    TRK=${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk
    CMD="fe2trk $MAT $REF $TRK"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
done

VAR=csddet
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    MAT=${FE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_life.mat
    TRK=${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk
    CMD="fe2trk $MAT $REF $TRK"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
done

VAR=csdprob
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    MAT=${FE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_life.mat
    TRK=${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk
    CMD="fe2trk $MAT $REF $TRK"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
done

VAR=dtidet
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck
TCK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk \
	-o ${TCK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.tck \
	-a ${REF}
done

VAR=csddet
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck
TCK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk \
	-o ${TCK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.tck \
	-a ${REF}
done

VAR=csdprob
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck
TCK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk \
	-o ${TCK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.tck \
	-a ${REF}
done


### AFQ DISSECTION

/N/dc2/projects/o3d/code/init_dissection_fe2trk.sh HCP7T ${SUB} dtidet
/N/dc2/projects/o3d/code/init_dissection_fe2trk.sh HCP7T ${SUB} csddet
/N/dc2/projects/o3d/code/init_dissection_fe2trk.sh HCP7T ${SUB} csdprob

