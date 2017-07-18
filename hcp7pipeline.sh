#!/bin/sh

ID=$1

SRC=/N/dc2/projects/lifebid/HCP7/$ID

OUT=/N/dc2/projects/o3d/HCP7/${ID}_bis
mkdir -p $OUT

DWI_SRC=$SRC/original_hcp_data/Diffusion_7T/data.nii.gz
BVEC_SRC=$SRC/original_hcp_data/Diffusion_7T/bvecs
BVAL_SRC=$SRC/original_hcp_data/Diffusion_7T/bvals

DWI=$OUT/${ID}_b2000.nii.gz
BVEC=$OUT/${ID}_b2000.bvecs
BVAL=$OUT/${ID}_b2000.bvals

ACPC=$OUT/${ID}_acpc.nii.gz
REF=$OUT/${ID}_dwi_wm_mask.nii.gz

MY_SHELL_EXTRACT=/N/dc2/projects/o3d/code/utils/my_shell_extract.py
MY_GTAB=/N/dc2/projects/o3d/code/utils/gtab.sh
MY_WM=/N/dc2/projects/o3d/code/utils/wm_from_aparc_aseg.py
MY_FLIP=/N/dc2/projects/o3d/code/utils/flip_bvecs.py


###
### Shell Extraction
###

${MY_SHELL_EXTRACT} \
    -i $DWI_SRC -ibvec $BVEC_SRC -ibval $BVAL_SRC \
    -o $DWI -obvec $BVEC -obval $BVAL \
    -b 0 2000 \
    -delta 200 \
    -r


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

#SUBJECTS_DIR=$OUT
#mkdir -p $OUT/freesurfer
#recon-all -all -i $ACPC -s freesurfer -parallel

#mri_convert $OUT/freesurfer/mri/aparc+aseg.mgz \
#    $OUT/freesurfer/mri/aparc+aseg.nii.gz

APARC=${SRC}/anatomy/freesurfer/mri/aparc+aseg.nii.gz
${MY_WM} $APARC $OUT/${ID}_wm_mask.nii.gz



###
### dtiInit
###

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"
ACPC=$OUT/${ID}_acpc.nii.gz

YFLIP=0
if [ $YFLIP == 1 ]; then
    if [ ! -f $OUT/${ID}_b2000.ybvecs ]; then
	${MY_FLIP} $BVEC $OUT/${ID}_b2000.ybvecs
    fi
    cp $OUT/${ID}_b2000.ybvecs $BVEC
fi

CMD="hcp7dtiInit $DWI $BVAL $BVEC $ACPC $OUT"
matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"


###
### MRTRIX setting
###

module unload mrtrix
module load mrtrix/0.2.12

DWI=$OUT/${ID}_b2000_aligned_trilin_noMEC.nii.gz
BVEC=$OUT/${ID}_b2000_aligned_trilin_noMEC.bvecs
BVAL=$OUT/${ID}_b2000_aligned_trilin_noMEC.bvals
GTAB=$OUT/${ID}_b2000_aligned_trilin_noMEC.gtab
WM=$OUT/${ID}_dwi_wm_mask.mif
B0=$OUT/dti64trilin/bin/b0.nii.gz 
MIF=$OUT/${ID}_b2000_aligned_trilin_noMEC

ALL_VAR='dtidet csddet csdprob'
ALL_NUM='01 02 03 04 05 06 07 08 09 10'

LMAX=8

${MY_GTAB} $BVEC $BVAL $GTAB


###
### Model Response
###

flirt -in ${OUT}/${ID}_wm_mask.nii.gz -ref ${B0} -out ${OUT}/${ID}_dwi_wm_mask.nii.gz
mrconvert ${OUT}/${ID}_dwi_wm_mask.nii.gz ${WM}

mrconvert $DWI $MIF.mif
dwi2tensor ${MIF}.mif -grad $GTAB ${MIF}_dt.mif
tensor2FA ${MIF}_dt.mif - | mrmult - $WM ${MIF}_fa.mif
erode ${WM} -npass 3 - | mrmult ${MIF}_fa.mif - - | threshold - -abs 0.7 ${MIF}_sf.mif

estimate_response ${MIF}.mif ${MIF}_sf.mif -lmax $LMAX -grad $GTAB ${MIF}_response.txt


###
### Model reconstruction
###

csdeconv ${MIF}.mif \
    -grad $GTAB \
    ${MIF}_response.txt \
    -lmax $LMAX \
    -mask $WM \
    ${MIF}_lmax${LMAX}.mif 


###
### Tracking
###

VAR_DT_STREAM=dtidet
VAR_SD_STREAM=csddet
VAR_SD_PROB=csdprob

REF=$OUT/${ID}_dwi_wm_mask.nii.gz

NUMFIBERS=500000
MAXNUMFIBERSATTEMPTED=1500000

for N in $ALL_NUM; do
    VAR=dtidet
    streamtrack DT_STREAM ${MIF}.mif \
	$OUT/${ID}_${VAR}_run-${N}.tck \
	-seed $WM \
	-mask $WM \
	-grad $GTAB \
	-number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
done

for N in $ALL_NUM; do
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

for VAR in $ALL_VAR; do
    for N in $ALL_NUM; do
	TractConverter.py \
	    -i ${OUT}/${ID}_${VAR}_run-${N}.tck \
	    -o ${OUT}/${ID}_${VAR}_run-${N}.trk \
	    -a ${REF} -f
    done
done


###
### Life
###

DWI=$OUT/${ID}_b2000_aligned_trilin_noMEC.nii.gz
REF=$OUT/${ID}_dwi_wm_mask.nii.gz

#ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD1="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"

for VAR in $ALL_VAR; do
    for N in $ALL_NUM; do
	TCK=${OUT}/${ID}_${VAR}_run-${N}.tck
	MAT=${OUT}/${ID}_${VAR}_run-${N}_life.mat
	CMD="life_eval $TCK $DWI $MAT"
	matlab -nojvm -nodesktop -nosplash -r "${ADD1};${CMD};exit"
    done
done

for VAR in $ALL_VAR; do
    for N in $ALL_NUM; do
	TRK=${OUT}/${ID}_${VAR}life_run-${N}_RAS.trk
	MAT=${OUT}/${ID}_${VAR}_run-${N}_life.mat
	CMD="fe2trk $MAT $REF $TRK"
	matlab -nojvm -nodesktop -nosplash -r "${ADD1};${CMD};exit"
    done
done


REF=$OUT/${ID}_dwi_wm_mask.nii.gz

for VAR in $ALL_VAR; do
    for N in $ALL_NUM; do
	TractConverter.py \
	    -i ${OUT}/${ID}_${VAR}life_run-${N}_RAS.trk \
	    -o ${OUT}/${ID}_${VAR}life_run-${N}.trk \
	    -a ${REF} -f
	TractConverter.py \
	    -i ${OUT}/${ID}_${VAR}life_run-${N}.trk \
	    -o ${OUT}/${ID}_${VAR}life_run-${N}.tck \
	    -a ${REF} -f
	rm ${OUT}/${ID}_${VAR}life_run-${N}_RAS.trk
    done
done



###
### AFQ Dissection
###

AFQ_CLEAN=1
REF=${OUT}/${ID}_dwi_wm_mask.nii.gz
DT6=${OUT}/dti64trilin/dt6.mat
AFQ=${OUT}/afq_dissection
mkdir -p ${AFQ} 

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"
ADD3="addpath(genpath('/N/dc2/projects/lifebid/code/franpest/AFQ'))"

for VAR in $ALL_VAR; do
    for N in $ALL_NUM; do
	TRK=${AFQ}/${ID}_${VAR}life_run-${N}_RAS
	MAT=${OUT}/${ID}_${VAR}_run-${N}_life.mat
	if [ $AFQ_CLEAN == 1 ]; then
	    CMD="afqClean4life2trk $MAT $DT6 $REF $TRK"
	else
	    CMD="afq4life2trk $MAT $DT6 $REF $TRK"
	fi
	matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${ADD3};${CMD};exit"
    done
done

SET='ATRl ATRr CSTl CSTr CCgl CCgr CHyl CHyr FMJ FMI IFOFl IFOFr ILFl ILFr SLFl SLFr UFl UFr ARCl ARCr'
REF=${OUT}/${ID}_dwi_wm_mask.nii.gz
AFQ=${OUT}/afq_dissection

for VAR in $ALL_VAR; do
    for S in $SET; do
	echo $SUB $VAR $S
	for N in $ALL_NUM; do
	    TractConverter.py \
		-i ${AFQ}/${ID}_${VAR}life_run-${N}_RAS_set-${S}_tract.trk \
		-o ${AFQ}/${ID}_${VAR}life_run-${N}_set-${S}_tract.trk \
		-a ${REF} -f
	    TractConverter.py \
		-i ${AFQ}/${ID}_${VAR}life_run-${N}_set-${S}_tract.trk \
		-o ${AFQ}/${ID}_${VAR}life_run-${N}_set-${S}_tract.tck \
		-a ${REF} -f
	    rm ${AFQ}/${ID}_${VAR}life_run-${N}_RAS_set-${S}_tract.trk
	done
    done
done

