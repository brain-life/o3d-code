#!/bin/bash

SUB=$1
OUT=$2

ID_0009=102311
ID_0010=109123
ID_0011=111312
ID_0012=125525

ID=$(eval echo "\$ID_$SUB")

SRC=/N/dc2/projects/lifebid/HCP7



### PREPROCESS ANAT
#
#mkdir -p ${OUT}/derivatives/preprocess/sub-${SUB}/anat
#
#cp ${SRC}/${ID}/anatomy/T1w_acpc_dc_restore_1.05_ACPC.nii.gz \
#    ${OUT}/derivatives/preprocess/sub-${SUB}/anat/sub-${SUB}_T1w.nii.gz
#
#
#### PREPROCESS DWI
#
#DWI=data_b2000_aligned_trilin_noMEC
#
#mkdir -p ${OUT}/derivatives/preprocess/sub-${SUB}/dwi
#
#cp ${SRC}/${ID}/dt6/${DWI}.nii.gz \
#    ${OUT}/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi.nii.gz
#cp ${SRC}/${ID}/dt6/${DWI}.bvals \
#    ${OUT}/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi.bvals
#cp ${SRC}/${ID}/dt6/${DWI}.bvecs \
#    ${OUT}/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi.bvecs
#cp ${SRC}/${ID}/dt6/dti64trilin/bin/brainMask.nii.gz \
#    ${OUT}/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_dwi_brainmask.nii.gz
#
#
#### RECON MODELS
#
#mkdir -p ${OUT}/derivatives/recon_models/sub-${SUB}/anat
#
#cp ${SRC}/${ID}/dt6/dti64trilin/bin/wmMask.nii.gz \
#    ${OUT}/derivatives/recon_models/sub-${SUB}/anat/sub-${SUB}_T1_wmmask.nii.gz
#
#mkdir -p ${OUT}/O3D_HCP7T/derivatives/recon_models/sub-${SUB}/dwi
#
#mrconvert ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_dt.mif \
#    ${OUT}/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_DTI.nii.gz \
#    -force
#mrconvert ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_ev.mif \
#    ${OUT}/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_EV.nii.gz \
#    -force
#mrconvert ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_fa.mif \
#    ${OUT}/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_FA.nii.gz \
#    -force
#mrconvert ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_lmax8.mif \
#    ${OUT}/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_ODF.nii.gz \
#    -force
#cp ${SRC}/${ID}/tractography/data_b2000_aligned_trilin_noMEC_response.txt \
#    ${OUT}/derivatives/recon_models/sub-${SUB}/dwi/sub-${SUB}_b-2000_dwi_dwiresponse.txt



### TRACTOGRAPHY

TCK=data_b2000_aligned_trilin_noMEC

mkdir -p ${OUT}/derivatives/tracking_dtidet_tck/sub-${SUB}
for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${SRC}/${ID}/tractography/${TCK}_wm_tensor-NUM${N}-500000.tck \
	${OUT}/derivatives/tracking_dtidet_tck/sub-${SUB}/sub-${SUB}_dwi_var-dtidet_run-${N}_tract.tck
done

mkdir -p ${OUT}/derivatives/tracking_csddet_tck/sub-${SUB}
for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${SRC}/${ID}/tractography/${TCK}_csd_lmax8_wm_SD_STREAM-NUM${N}-500000.tck \
	${OUT}/derivatives/tracking_csddet_tck/sub-${SUB}/sub-${SUB}_dwi_var-csddet_run-${N}_tract.tck
done

mkdir -p ${OUT}/derivatives/tracking_csdprob_tck/sub-${SUB}
for N in 01 02 03 04 05 06 07 08 09 10; do
    cp ${SRC}/${ID}/tractography/${TCK}_csd_lmax8_wm_SD_PROB-NUM${N}-500000.tck \
	${OUT}/derivatives/tracking_csdprob_tck/sub-${SUB}/sub-${SUB}_dwi_var-csdprob_run-${N}_tract.tck
done


REF=${OUT}/derivatives/preprocess/sub-${SUB}/dwi/sub-${SUB}_dwi_brainmask.nii.gz

mkdir -p ${OUT}/derivatives/tracking_dtidet_trk/sub-${SUB}
TCK=${OUT}/derivatives/tracking_dtidet_tck/sub-${SUB}
TRK=${OUT}/derivatives/tracking_dtidet_trk/sub-${SUB}
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TCK}/sub-${SUB}_dwi_var-dtidet_run-${N}_tract.tck \
	-o ${TRK}/sub-${SUB}_dwi_var-dtidet_run-${N}_tract.trk \
	-a ${REF} -f
done

mkdir -p ${OUT}/derivatives/tracking_csddet_trk/sub-${SUB}
TCK=${OUT}/derivatives/tracking_csddet_tck/sub-${SUB}
TRK=${OUT}/derivatives/tracking_csddet_trk/sub-${SUB}
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TCK}/sub-${SUB}_dwi_var-csddet_run-${N}_tract.tck \
	-o ${TRK}/sub-${SUB}_dwi_var-csddet_run-${N}_tract.trk \
	-a ${REF} -f
done

mkdir -p ${OUT}/derivatives/tracking_csdprob_trk/sub-${SUB}
TCK=${OUT}/derivatives/tracking_csdprob_tck/sub-${SUB}
TRK=${OUT}/derivatives/tracking_csdprob_trk/sub-${SUB}
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TCK}/sub-${SUB}_dwi_var-csdprob_run-${N}_tract.tck \
	-o ${TRK}/sub-${SUB}_dwi_var-csdprob_run-${N}_tract.trk \
	-a ${REF} -f
done

exit

### LIFE STRUCT

FE=/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/Revision_Feb2017/Results/Single_TC/fe_structures

mkdir -p ${OUT}/O3D_HCP7T/derivatives/life_struct/sub-${SUB}/dwi

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

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"

VAR=dtidet
PRE=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    MAT=${FE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_life.mat
    TRK=${PRE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk
    RAS=${PRE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract_RAS.trk
    CMD="fe2trk $MAT $REF $RAS"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
    TractConverter.py -i $RAS -o $TRK -a $REF -f
    rm $RAS
done

VAR=csddet
PRE=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    MAT=${FE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_life.mat
    TRK=${PRE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk
    RAS=${PRE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract_RAS.trk
    CMD="fe2trk $MAT $REF $RAS"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
    TractConverter.py -i $RAS -o $TRK -a $REF -f
    rm $RAS
done

VAR=csdprob
PRE=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    MAT=${FE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_life.mat
    TRK=${PRE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk
    RAS=${PRE}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract_RAS.trk
    CMD="fe2trk $MAT $REF $RAS"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
    TractConverter.py -i $RAS -o $TRK -a $REF -f
    rm $RAS
done


VAR=dtidet
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck
TCK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk \
	-o ${TCK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.tck \
	-a ${REF} -f
done

VAR=csddet
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck
TCK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk \
	-o ${TCK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.tck \
	-a ${REF} -f
done

VAR=csdprob
mkdir -p ${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck
TCK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_tck/sub-${SUB}/dwi
TRK=${OUT}/O3D_HCP7T/derivatives/tracking_${VAR}_trk/sub-${SUB}/dwi
for N in 01 02 03 04 05 06 07 08 09 10; do
    TractConverter.py \
	-i ${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.trk \
	-o ${TCK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_tract.tck \
	-a ${REF} -f
done


### AFQ DISSECTION

/N/dc2/projects/o3d/code/init_dissection_fe2trk.sh HCP7T ${SUB} test3 dtidet
/N/dc2/projects/o3d/code/init_dissection_fe2trk.sh HCP7T ${SUB} test3 csddet
/N/dc2/projects/o3d/code/init_dissection_fe2trk.sh HCP7T ${SUB} test3 csdprob

SET='ATRl ATRr CSTl CSTr CCgl CCgr CHyl CHyr FMJ FMI IFOFl IFOFr ILFl ILFr SLFl SLFr UFl UFr ARCl ARCr'

VAR=dtidet
TCK=${OUT}/O3D_HCP7T/derivatives/dissection_${VAR}_tck/sub-${SUB}/dwi/
TRK=${OUT}/O3D_HCP7T/derivatives/dissection_${VAR}_trk/sub-${SUB}/dwi/

mkdir -p ${OUT}/O3D_HCP7T/derivatives/dissection_${VAR}_tck/sub-${SUB}/dwi

for S in $SET; do
    for N in 01 02 03 04 05 06 07 08 09 10; do
	TractConverter.py \
	    -i ${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_var-afq_set-${S}_tract.trk \
	    -o ${TCK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_var-afq_set-${S}_tract.tck \
	    -a ${REF} -f
    done
done


VAR=csddet
TCK=${OUT}/O3D_HCP7T/derivatives/dissection_${VAR}_tck/sub-${SUB}/dwi/
TRK=${OUT}/O3D_HCP7T/derivatives/dissection_${VAR}_trk/sub-${SUB}/dwi/

mkdir -p ${OUT}/O3D_HCP7T/derivatives/dissection_${VAR}_tck/sub-${SUB}/dwi

for S in $SET; do
    for N in 01 02 03 04 05 06 07 08 09 10; do
	TractConverter.py \
	    -i ${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_var-afq_set-${S}_tract.trk \
	    -o ${TCK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_var-afq_set-${S}_tract.tck \
	    -a ${REF} -f
    done
done


VAR=csdprob
TCK=${OUT}/O3D_HCP7T/derivatives/dissection_${VAR}_tck/sub-${SUB}/dwi/
TRK=${OUT}/O3D_HCP7T/derivatives/dissection_${VAR}_trk/sub-${SUB}/dwi/

mkdir -p ${OUT}/O3D_HCP7T/derivatives/dissection_${VAR}_tck/sub-${SUB}/dwi

for S in $SET; do
    for N in 01 02 03 04 05 06 07 08 09 10; do
	TractConverter.py \
	    -i ${TRK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_var-afq_set-${S}_tract.trk \
	    -o ${TCK}/sub-${SUB}_dwi_var-${VAR}life_run-${N}_var-afq_set-${S}_tract.tck \
	    -a ${REF} -f
    done
done


### CONNECTOME

