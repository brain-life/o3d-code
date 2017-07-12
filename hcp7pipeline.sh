#!/bin/sh

ID=$1

SRC=/N/dc2/projects/lifebid/HCP7/$ID

OUT=/N/dc2/projects/o3d/temp/$ID
mkdir -p $OUT

DWI_SRC=$SRC/original_hcp_data/Diffusion_7T/data.nii.gz
BVEC_SRC=$SRC/original_hcp_data/Diffusion_7T/bvecs
BVAL_SRC=$SRC/original_hcp_data/Diffusion_7T/bvals

DWI=$OUT/${ID}_b2000.nii.gz
BVEC=$OUT/${ID}_b2000.bvecs
BVAL=$OUT/${ID}_b2000.bvals
GTAB=$OUT/${ID}_b2000.gtab

MY_SHELL_EXTRACT=/N/dc2/projects/o3d/code/utils/my_shell_extract.py
MY_GTAB=/N/dc2/projects/o3d/code/utils/gtab.sh
MY_WM=/N/dc2/projects/o3d/code/utils/wm_from_aparc_aseg.py

if [ 0 == 1 ]; then
###
### Shell Extraction
###

${MY_SHELL_EXTRACT} \
    -i $DWI_SRC -ibvec $BVEC_SRC -ibval $BVAL_SRC \
    -o $DWI -obvec $BVEC -obval $BVAL \
    -b 0 2000 \
    -delta 200 \
    -round

${MY_GTAB} $BVEC $BVAL $GTAB


###
### ACPC Alignment
###

T1W=$SRC/original_hcp_data/T1w/T1w_acpc_dc_restore_1.05.nii.gz
ACPC=$OUT/${ID}_acpc.nii.gz

module load spm/8
ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"

CMD="hcp7acpc $T1W $ACPC"
matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"


###
### Freesurfer
###

ACPC=$OUT/${ID}_acpc.nii.gz

SUBJECTS_DIR=$OUT
#mkdir -p $OUT/freesurfer
recon-all -all -i $ACPC -s freesurfer -parallel

mri_convert $OUT/freesurfer/mri/aparc+aseg.mgz \
    $OUT/freesurfer/mri/aparc+aseg.nii.gz
${MY_WM} $OUT/freesurfer/mri/aparc+aseg.nii.gz $OUT/${ID}_wm_mask.nii.gz


###
### dtiInit
###

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"
ACPC=$OUT/${ID}_acpc.nii.gz

CMD="hcp7dtiInit $DWI $BVAL $BVEC $ACPC $OUT"
#matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
matlab -r "${ADD1};${ADD2};${CMD};exit"


###
### Model Response
###

DWI=$OUT/${ID}_b2000_aligned_trilin_noMEC.nii.gz
BVEC=$OUT/${ID}_b2000_aligned_trilin_noMEC.bvecs
BVAL=$OUT/${ID}_b2000_aligned_trilin_noMEC.bvals
GTAB=$OUT/${ID}_b2000_aligned_trilin_noMEC.gtab
WM=$OUT/${ID}_dwi_wm_mask.mif
B0=$OUT/dti64trilin/bin/b0.nii.gz 
MIF=$OUT/${ID}_b2000_aligned_trilin_noMEC

${MY_GTAB} $BVEC $BVAL $GTAB

#flirt -in ${OUT}/${ID}_wm_mask.nii.gz -ref ${B0} -out ${OUT}/${ID}_dwi_wm_mask.nii.gz
#mrconvert ${OUT}/${ID}_dwi_wm_mask.nii.gz ${WM}

#mrconvert $DWI $MIF.mif
#dwi2tensor ${MIF}.mif -grad $GTAB ${MIF}_dt.mif
#tensor2FA ${MIF}_dt.mif - | mrmult - $WM ${MIF}_fa.mif
#erode ${WM} -npass 3 - | mrmult ${MIF}_fa.mif - - | threshold - -abs 0.7 ${MIF}_sf.mif

#estimate_response ${MIF}.mif ${MIF}_sf.mif -lmax 6 -grad $GTAB ${MIF}_response.txt

###
### Model reconstruction
###

#LMAX=8

#csdeconv ${MIF}.mif \
#    -grad $GTAB \
#    ${MIF}_response.txt \
#    -lmax $LMAX \
#    -mask $WM \
#    ${MIF}_lmax${LMAX}.mif 


###
### Tracking
###

VAR_DT_STREAM=_dtidet
VAR_SD_STREAM=_csddet
VAR_SD_PROB=csdprob

NUMFIBERS=500000
MAXNUMFIBERSATTEMPTED=1500000

#for N in 01 02 03 04 05 06 07 08 09 10; do
for N in 01; do
    VAR=dtidet
    streamtrack DT_STREAM ${MIF}.mif \
	$OUT/${ID}_${VAR}_run-${N}.tck \
	-seed $WM \
	-mask $WM \
	-grad $GTAB \
	-number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
done

#for N in 01 02 03 04 05 06 07 08 09 10; do
for N in 01; do
    for T in SD_STREAM SD_PROB; do
	VAR=$(eval echo "\$VAR_$T")
	streamtrack $T ${MIF}_lmax${LMAX}.mif \
	    $OUT/${ID}_${VAR}_run-${N}.tck \
	    -seed $WM \
	    -mask $WM \
	    -grad $GTAB \
	    -number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
    done
done

fi


###
### Life
###

DWI=$OUT/${ID}_b2000_aligned_trilin_noMEC.nii.gz

#ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD1="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"

#for VAR in dtidet csddet csdprob; do
for VAR in dtidet; do
    #for N in 01 02 03 04 05 06 07 08 09 10; do
    for N in 01; do
	TCK=${OUT}/${ID}_${VAR}.tck
	MAT=${OUT}/${ID}_${VAR}_run-${N}_life.mat
	CMD="life_eval $TCK $DWI $MAT"
	matlab -nojvm -nodesktop -nosplash -r "${ADD1};${CMD};exit"
    done
done



###
### AFQ Dissection
###

AFQ_CLEAN=0
REF=${OUT}/${ID}_dwi_wm_mask.nii.gz
DT6=${OUT}/dti64trilin
AFQ=${OUT}/afq_dissection
mkdir -p ${AFQ} 

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"
ADD3="addpath(genpath('/N/dc2/projects/lifebid/code/franpest/AFQ'))"

#for VAR in dtidet csddet csdprob; do
for VAR in dtidet; do
    #for N in 01 02 03 04 05 06 07 08 09 10; do
    for N in 01; do
	TRK=${AFQ}/${ID}_${VAR}life_run-${N}
	MAT=${OUT}/${ID}_${VAR}_run-${N}_life.mat
	if [ $AFQ_CLEAN ]; then
	    CMD="afqClean4life2trk $MAT $DT6 $REF $TRK"
	else
	    CMD="afq4life2trk $MAT $DT6 $REF $TRK"
	fi
	matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${ADD3};${CMD};exit"
    done
done
