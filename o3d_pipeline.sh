#!/bin/sh

ID=$1

if [ -z $2 ]; then
    O3D=HCP3
else
    O3D=$2
fi

###
### Source filenames
###

if [ $O3D == STN ]; then
    
    exit

elif [ $O3D == HCP3 ]; then

    SRC=/N/dc2/projects/lifebid/Paolo/data/HCP/${ID}
    T1W_SRC=$SRC/T1w/T1w_acpc_dc_restore_1.25.nii.gz
    T1W_MASK_SRC=$SRC/T1w/brainmask_fs.nii.gz
    DWI_SRC=$SRC/T1w/Diffusion/data.nii.gz
    BVEC_SRC=$SRC/T1w/Diffusion/bvecs
    BVAL_SRC=$SRC/T1w/Diffusion/bvals
    DWI_MASK_SRC=${SRC}/T1w/Diffusion/nodif_brain_mask.nii.gz
    APARC_SRC=${SRC}/T1w/aparc+aseg.nii.gz

elif [ $O3D == HCP7 ]; then

    SRC=/N/dc2/projects/lifebid/HCP7/$ID
    T1W_SRC=$SRC/original_hcp_data/T1w/T1w_acpc_dc_restore_1.05.nii.gz
    T1W_MASK_SRC=$SRC/T1w/T1w_acpc_dc_restore_1.25.nii.gz
    DWI_SRC=$SRC/original_hcp_data/Diffusion_7T/data.nii.gz
    BVEC_SRC=$SRC/original_hcp_data/Diffusion_7T/bvecs
    BVAL_SRC=$SRC/original_hcp_data/Diffusion_7T/bvals
    DWI_MASK_SRC=${SRC}/original_hcp_data/Diffusion_7T/nodif_brain_mask.nii.gz
    APARC_SRC=${SRC}/anatomy/freesurfer/mri/aparc+aseg.nii.gz

else
 
    echo 'Non supported dataset.'
    exit

fi


###
### Setting filenames
###

OUT=/N/dc2/projects/o3d/sandbox/${O3D}

T1W=$OUT/preprocess/sub-${ID}/anat/sub-${ID}_T1w.nii.gz
T1W_MASK=$OUT/preprocess/sub-${ID}/anat/sub-${ID}_T1w_brainmask.nii.gz
T1W_WMM=${OUT}/preprocess/sub-${ID}/anat/sub-${ID}_T1w_wmmask.nii.gz
ACPC=$OUT/preprocess/sub-${ID}/anat/sub-${ID}_T1w_acpc.nii.gz
APARC=$OUT/preprocess/sub-${ID}/anat/sub-${ID}_T1w_aparc.nii.gz

DWI=$OUT/preprocess/sub-${ID}/dwi/sub-${ID}_b-2000_dwi
DWI_MASK=$OUT/preprocess/sub-${ID}/dwi/sub-${ID}_b-2000_dwi_brainmask.nii.gz
B0=${OUT}/preprocess/sub-${ID}/dwi/dti64trilin/bin/b0.nii.gz
DT6=${OUT}/preprocess/sub-${ID}/dwi/dti64trilin/dt6.mat

DTI=$OUT/recon_models/sub-${ID}/sub-${ID}_b-2000_DTI
EV=$OUT/recon_models/sub-${ID}/sub-${ID}_b-2000_EV
FA=$OUT/recon_models/sub-${ID}/sub-${ID}_b-2000_FA
ODF=$OUT/recon_models/sub-${ID}/sub-${ID}_b-2000_ODF
RES=$OUT/recon_models/sub-${ID}/sub-${ID}_b-2000_dwiresponse.txt
REF=$OUT/recon_models/sub-${ID}/sub-${ID}_T1w_wmmask.nii.gz
WMM=$OUT/recon_models/sub-${ID}/sub-${ID}_T1w_wmmask.nii.gz
MIF=$OUT/recon_models/sub-${ID}/sub-${ID}_b2000_dwi

CON_LAB=$OUT/connectome_tract/sub-${ID}/sub-${ID}_connectome_labels.nii.gz
DWI_AFF=$OUT/connectome_tract/sub-${ID}/sub-${ID}_acpc2dwi_affine.mat

MY_SHELL_EXTRACT=/N/dc2/projects/o3d/code/utils/my_shell_extract.py
MY_GTAB=/N/dc2/projects/o3d/code/utils/gtab.sh
MY_WM=/N/dc2/projects/o3d/code/utils/wm_from_aparc_aseg.py

ADD1="addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'))"
ADD2="addpath(genpath('/N/dc2/projects/o3d/code/utils'))"
ADD3="addpath(genpath('/N/dc2/projects/lifebid/code/franpest/AFQ'))"

mkdir -p $OUT/preprocess/sub-${ID}/anat
mkdir -p $OUT/preprocess/sub-${ID}/dwi
mkdir -p $OUT/recon_models/sub-${ID}
mkdir -p $OUT/tracking_dtidet_trk/sub-${ID}
mkdir -p $OUT/tracking_dtidet_tck/sub-${ID}
mkdir -p $OUT/tracking_csddet_trk/sub-${ID}
mkdir -p $OUT/tracking_csddet_tck/sub-${ID}
mkdir -p $OUT/tracking_csdprob_trk/sub-${ID}
mkdir -p $OUT/tracking_csdprob_tck/sub-${ID}
mkdir -p $OUT/life_struct/sub-${ID}
mkdir -p $OUT/dissection_afq_dtidet_trk/sub-${ID}
mkdir -p $OUT/dissection_afq_dtidet_tck/sub-${ID}
mkdir -p $OUT/dissection_afq_csddet_trk/sub-${ID}
mkdir -p $OUT/dissection_afq_csddet_tck/sub-${ID}
mkdir -p $OUT/dissection_afq_csdprob_trk/sub-${ID}
mkdir -p $OUT/dissection_afq_csdprob_tck/sub-${ID}
mkdir -p $OUT/connectome_tract/sub-${ID}
mkdir -p $OUT/freesurfer/sub-${ID}

STEP_ACPC_ALIGNMENT=0
STEP_FREESURFER=0
STEP_SHELL_EXTRACTION=1
STEP_DTI_INIT=0
STEP_WHITE_MATTER_MASK=0
STEP_MODEL_RECONSTRUCTION=0
STEP_TRACKING_DTI=0
STEP_TRACKING_DET=0
STEP_TRACKING_PROB=0
STEP_LIFE=0
STEP_DISSECTION_AFQ_DTI=0
STEP_DISSECTION_AFQ_DET=0
STEP_DISSECTION_AFQ_PROB=0
STEP_DISSECTION_AFQ_CLEAN=0
STEP_DISSECTION_WMQL_DTI=0
STEP_DISSECTION_WMQL_DET=0
STEP_DISSECTION_WMQL_PROB=0
STEP_CONNECTOME=0
STEP_CLEAN=0

SET='ARCl ARCr ATRl ATRr CSTl CSTr CCgl CCgr CHyl CHyr FMJ FMI IFOFl IFOFr ILFl ILFr SLFl SLFr UFl UFr'
ALL_VAR='dtidet csddet csdprob'
ALL_NUM='01 02 03 04 05 06 07 08 09 10'

MRTRIX2=1


###
### ACPC Alignment
###

if [ $STEP_ACPC_ALIGNMENT == 1 ]; then

    module load spm/8
    CMD="hcp7acpc $T1W $ACPC"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"

    flirt -in $T1W -ref $ACPC -omat ${OUT}/${ID}_orig2acpc_affine.mat
    flirt -in ${MASK_SRC} \
	-ref $ACPC \
	-applyxfm -init ${OUT}/${ID}_orig2acpc_affine.mat \
	-out ${OUT}/${ID}_acpc_brainmask.nii.gz -interp nearestneighbour

else

    cp $T1W_SRC $T1W
    flirt -in  $T1W_MASK_SRC \
	-ref $DWI_MASK_SRC \
	-out $T1W_MASK \
	-interp nearestneighbour
    ACPC=$T1W

fi


###
### Freesurfer
###

if [ $STEP_FREESURFER == 1 ]; then

    SUBJECTS_DIR=$OUT
    mkdir -p $OUT/freesurfer/${ID}
    recon-all -all -i $ACPC -s freesurfer -parallel
    mri_convert $OUT/freesurfer/mri/aparc+aseg.mgz \
	$OUT/freesurfer/mri/aparc+aseg.nii.gz

else

    cp $APARC_SRC $APARC

fi


###
### Shell Extraction
###

if [ $STEP_SHELL_EXTRACTION == 1 ]; then
    ${MY_SHELL_EXTRACT} \
	-i $DWI_SRC -ibvec $BVEC_SRC -ibval $BVAL_SRC \
	-o ${DWI}.nii.gz -obvec ${DWI}.bvecs -obval ${DWI}.bvals \
	-b 0 2000 \
	-delta 200 \
	-r
else
    cp $DWI_SRC ${DWI}.nii.gz
    cp $BVEC_SRC ${DWI}.bvecs
    cp $BVAL_SRC ${DWI}.bvals
fi


###
### dtiInit
###

if [ $STEP_DTI_INIT == 1 ]; then

    TMP=${OUT}/preprocess/sub-${ID}
    CMD="O3DdtiInit ${DWI}.nii.gz ${DWI}.bvals ${DWI}.bvecs $ACPC $TMP"
    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
    
    mv ${DWI}_aligned_trilin_noMEC.nii.gz ${DWI}.nii.gz
    mv ${DWI}_aligned_trilin_noMEC.bvecs ${DWI}.bvecs
    mv ${DWI}_aligned_trilin_noMEC.bvals ${DWI}.bvals
    
    B0=${TMP}/dti64trilin/bin/b0.nii.gz 

fi


###
### White Matter Mask
###

if [ $STEP_WHITE_MATTER_MASK == 1 ]; then

    ${MY_WM} $APARC $T1W_WMM
    flirt -in ${T1W_WMM} \
	-ref ${B0} \
	-out ${WMM} \
	-interp nearestneighbour

fi


###
### MRTRIX setting
###

module unload mrtrix

if [ $MRTRIX2 == 1 ]; then
    module load mrtrix/0.2.12
else
    module load mrtrix/0.3.15
fi

LMAX=8
NUMFIBERS=500000
MAXNUMFIBERSATTEMPTED=1500000




###
### Model reconstruction
###

if [ $STEP_MODEL_RECONSTRUCTION == 1 ]; then

    mrconvert ${DWI}.nii.gz ${MIF}.mif -f
    mrconvert ${WMM} ${MIF}_wmm.mif -f
    ${MY_GTAB} ${DWI}.bvecs ${DWI}.bvals ${MIF}.gtab

    if [ $MRTRIX2 == 1 ]; then

	dwi2tensor ${MIF}.mif -grad ${MIF}.gtab ${DTI}.mif
	tensor2FA ${DTI}.mif - | \
	    mrmult - ${MIF}_wmm.mif ${FA}.mif
	tensor2vector ${DTI}.mif - | \
	    mrmult - ${FA}.mif ${EV}_ev.mif
	erode ${MIF}_wmm.mif -npass 3 - | \
	    mrmult ${FA}.mif - - | \
	    threshold - -abs 0.7 ${MIF}_sf.mif
	estimate_response ${MIF}.mif ${MIF}_sf.mif -lmax $LMAX -grad ${MIF}.gtab ${RES}
	
    else
	
	tensor2metric -fa ${DTI}.mif - | \
	    mrmath - ${MIF}_wmm.mif product ${FA}.mif
	tensor2metric -vector ${DTI}.mif - | \
	    mrmath - ${FA}.mif product ${EV}_ev.mif
	maskfilter ${MIF}_wmm.mif erode -npass 3 - | \
	    mrmath ${FA}.mif - product - | \
	    mrthreshold - -abs 0.7 ${MIF}_sf.mif
	dwi2response tournier ${MIF}.mif -sf_voxels ${MIF}_sf.mif -lmax $LMAX -grad ${MIF}.gtab ${RES}
	
    fi

    mrconvert ${FA}.mif ${FA}.nii.gz -f
    mrconvert ${EV}.mif ${EV}.nii.gz -f
    mrconvert ${DTI}.mif ${DTI}.nii.gz -f
    
    csdeconv ${MIF}.mif \
	-grad ${MIF}.gtab \
	${RES} \
	-lmax $LMAX \
	-mask ${MIF}_wmm.mif \
	${ODF}.mif 
    
    mrconvert ${ODF}.mif ${ODF}.nii.gz -f

fi


###
### Tracking
###

if [ $STEP_TRACKING_DTI == 1 ]; then
    VAR=dtidet
    DTI_TCK=${OUT}/tracking_${VAR}_tck/sub-${ID}
    DTI_TRK=${OUT}/tracking_${VAR}_trk/sub-${ID}
    for N in $ALL_NUM; do
	echo "Gneration of $VAR tractogram (iteration $N)"
	if [ $MRTRIX2 == 1 ]; then
	    streamtrack DT_STREAM ${ODF}.mif \
		${DTI_TCK}/sub-${ID}_var-${VAR}_run-${N}_tract.tck \
		-seed ${MIF}_wmm.mif \
		-mask ${MIF}_wmm.mif \
		-grad ${MIF}.gtab \
		-number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
	else
	    tckgen Tensor_Det ${ODF}.mif \
		${DTI_TCK}/sub-${ID}_var-${VAR}_run-${N}_tract.tck \
		-seed ${MIF}_wmm.mif \
		-mask ${MIF}_wmm.mif \
		-grad ${MIF}.gtab \
		-number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
	fi
    done
    for N in $ALL_NUM; do
	echo "Convert TCK/TRK files of $VAR tractogram (iteration $N)"
	TractConverter.py \
	    -i ${DTI_TCK}/sub-${ID}_var-${VAR}_run-${N}_tract.tck \
	    -o ${DTI_TRK}/sub-${ID}_var-${VAR}_run-${N}_tract.trk \
	    -a ${REF} -f 
    done

fi

if [ $STEP_TRACKING_DET == 1 ]; then
    VAR=csddet
    DET_TCK=${OUT}/tracking_${VAR}_tck/sub-${ID}
    DET_TCK=${OUT}/tracking_${VAR}_tck/sub-${ID}
    for N in $ALL_NUM; do
	echo "Gneration of $VAR tractogram (iteration $N)"
	if [ $MRTRIX2 == 1 ]; then
	    streamtrack SD_STREAM ${ODF}.mif \
		${DET_TCK}/sub-${ID}_var-${VAR}_run-${N}_tract.tck \
		-seed ${MIF}_wmm.mif \
		-mask ${MIF}_wmm.mif \
		-grad ${MIF}.gtab \
		-number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
	else
	    tckgen iFOD1 ${ODF}.mif \
		${DET_TCK}/sub-${ID}_var-${VAR}_run-${N}_tract.tck \
		-seed ${MIF}_wmm.mif \
		-mask ${MIF}_wmm.mif \
		-grad ${MIF}.gtab \
		-number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
	fi
    done
    for N in $ALL_NUM; do
	echo "Convert TCK/TRK files of $VAR tractogram (iteration $N)"
	TractConverter.py \
	    -i ${DET_TCK}/sub-${ID}_var-${VAR}_run-${N}_tract.tck \
	    -o ${DET_TRK}/sub-${ID}_var-${VAR}_run-${N}_tract.trk \
	    -a ${REF} -f 
    done

fi

if [ $STEP_TRACKING_PROB == 1 ]; then
    VAR=csdprob
    PROB_TCK=${OUT}/tracking_${VAR}_tck/sub-${ID}
    PROB_TRK=${OUT}/tracking_${VAR}_trk/sub-${ID}
    for N in $ALL_NUM; do
	echo "Gneration of $VAR tractogram (iteration $N)"
	if [ $MRTRIX2 == 1 ]; then
	    streamtrack SD_PROB ${ODF}.mif \
		${PROB_TCK}/sub-${ID}_var-${VAR}_run-${N}_tract.tck \
		-seed ${MIF}_wmm.mif \
		-mask ${MIF}_wmm.mif \
		-grad ${MIF}.gtab \
		-number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
	else
	    tckgen iFOD2 ${ODF}.mif \
		${PROB_TCK}/sub-${ID}_var-${VAR}_run-${N}_tract.tck \
		-seed ${MIF}_wmm.mif \
		-mask ${MIF}_wmm.mif \
		-grad ${MIF}.gtab \
		-number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
	fi
    done
    for N in $ALL_NUM; do
	echo "Convert TCK/TRK files of $VAR tractogram (iteration $N)"
	TractConverter.py \
	    -i ${PROB_TCK}/sub-${ID}_var-${VAR}_run-${N}_tract.tck \
	    -o ${PROB_TRK}/sub-${ID}_var-${VAR}_run-${N}_tract.trk \
	    -a ${REF} -f 
    done

fi


###
### Life
###

if [ $STEP_LIFE == 1 ]; then

    for VAR in $ALL_VAR; do 
	for N in $ALL_NUM; do
	    echo "Life Eval of $VAR tractogram (iteration $N)"
	    TCK=${OUT}/tracking_${VAR}_tck/sub-${ID}/sub-${ID}_var-${VAR}_run-${N}_tract.tck
	    MAT=${OUT}/life_struct/sub-${ID}/sub-${ID}_var-${VAR}_run-${N}_life.mat
	    CMD="life_eval $TCK ${DWI}.nii.gz $MAT"
	    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
	done
    done

    for VAR in $ALL_VAR; do
	for N in $ALL_NUM; do
	    echo "Writing TRK file of $VAR tractogram (iteration $N)"
	    TRK=${OUT}/tracking_${VAR}_trk/sub-${ID}/sub-${ID}_var-${VAR}life_run-${N}_RAS.trk
	    MAT=${OUT}/life_struct/sub-${ID}/sub-${ID}_var-${VAR}_run-${N}_life.mat
	    CMD="fe2trk $MAT $REF $TRK"
	    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${CMD};exit"
	done
    done

    for VAR in $ALL_VAR; do
	for N in $ALL_NUM; do
	    echo "Convert TRK/TCK files of $VAR tractogram (iteration $N)"
	    TractConverter.py \
		-i ${OUT}/tracking_${VAR}_trk/sub-${ID}/sub-${ID}_var-${VAR}life_run-${N}_RAS.trk \
		-o ${OUT}/tracking_${VAR}_trk/sub-${ID}/sub-${ID}_var-${VAR}life_run-${N}_tract.trk \
		-a ${REF} -f
	    TractConverter.py \
		-i ${OUT}/tracking_${VAR}_trk/sub-${ID}/sub-${ID}_var-${VAR}life_run-${N}_tract.trk \
		-o ${OUT}/tracking_${VAR}_tck/sub-${ID}/sub-${ID}_var-${VAR}life_run-${N}_tract.tck \
		-a ${REF} -f
	    rm ${OUT}/tracking_${VAR}_trk/sub-${ID}/sub-${ID}_var-${VAR}life_run-${N}_RAS.trk
	done
    done

fi



###
### AFQ Dissection
###

ALL_AFQ=' '
if [ $STEP_DISSECTION_AFQ_DTI == 1 ]; then
    ALL_AFQ='dtidet'$ALL_AFQ
fi
    
for VAR in $ALL_AFQ; do

    AFQ_TRK=${OUT}/dissection_afq_${VAR}_trk
    AFQ_TCK=${OUT}/dissection_afq_${VAR}_tck

    for N in $ALL_NUM; do
	echo "AFQ Dissection from $VAR tractogram (iteration $N)"
	TRK=${AFQ_TRK}/sub-${ID}/sub-${ID}_var-${VAR}life_run-${N}_var-afq_RAS
	MAT=${OUT}/life_struct/sub-${ID}/sub-${ID}_var-${VAR}_run-${N}_life.mat
	CMD="afq4life2trk $MAT $DT6 $REF $TRK"
	matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${ADD3};${CMD};exit"
    done

    for S in $SET; do
	for N in $ALL_NUM; do
	    echo "Convert dissected tract $S from $VAR tractogram (iteration $N)"
	    TractConverter.py \
		-i ${AFQ_TRK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-afq_RAS_set-${S}_tract.trk \
		-o ${AFQ_TRK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-afq_set-${S}_tract.trk \
		-a ${REF} -f
	    TractConverter.py \
		-i ${AFQ_TRK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-afq_set-${S}_tract.trk \
		-o ${AFQ_TCK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-afq_set-${S}_tract.tck \
		-a ${REF} -f
	    rm ${AFQ_TRK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-afq_RAS_set-${S}_tract.trk
	done
    done

    if [ $STEP_DISSECTION_AFQ_CLEAN == 1 ]; then
	for N in $ALL_NUM; do
	    echo "Clean dissection from $VAR tractogram (iteration $N)"
	    TRK=${AFQ_TRK}/sub-${ID}/sub-${ID}_var-${VAR}life_run-${N}_var-cafq_RAS
	    AFQ=${AFQ_TRK}/sub-${ID}/sub-${ID}_var-${VAR}life_run-${N}_var-afq_RAS_set-ALL.mat
	    CMD="clean_afq2trk $AFQ $REF $TRK"
	    matlab -nojvm -nodesktop -nosplash -r "${ADD1};${ADD2};${ADD3};${CMD};exit"
	done
	for S in $SET; do
	    for N in $ALL_NUM; do
		echo "Convert CLEAN dissected tract $S from $VAR tractogram (iteration $N)"
		TractConverter.py \
		    -i ${AFQ_TRK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-cafq_RAS_set-${S}_tract.trk \
		    -o ${AFQ_TRK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-cafq_set-${S}_tract.trk \
		    -a ${REF} -f
		TractConverter.py \
		    -i ${AFQ_TRK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-cafq_set-${S}_tract.trk \
		    -o ${AFQ_TCK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-cafq_set-${S}_tract.tck \
		    -a ${REF} -f
		rm ${AFQ_TRK}/sub-${ID}/sub-${ID}_${VAR}life_run-${N}_var-cafq_RAS_set-${S}_tract.trk
	    done
	done

    fi

done


###
### CONNECTOME
###

if [ $STEP_CONNECTOME == 1 ]; then

    if [ ! -f ${DWI_AFF} ]; then
	echo 'Computing affine acpc to dwi...'
	flirt -in ${T1W_WMM} \
	    -ref ${B0} \
	    -omat ${DWI_AFF} 
    fi
    
    if [ ! -f ${APARC} ]; then
	echo 'Computing the registration of aparc+aseg to dwi..'
	flirt -in ${APARC_SRC} \
	    -ref ${B0} \
	    -applyxfm -init ${DWI_AFF} \
	    -out ${APARC} \
	    -interp nearestneighbour
    fi

    if [ ! -f ${CON_LAB} ]; then
	echo 'Computing the connectome labels...'
	CMD="myfsInflatedDK $APARC 3 vert $CON_LAB"
	matlab -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
    fi
    
    for VAR in $ALL_VAR; do
	for N in $ALL_NUM; do
	    echo Computing connectome for $VAR \(iteration ${N}\)
	    FE=${OUT}/life_struct/sub-${ID}/sub-${ID}_var-${VAR}_run-${N}_life.mat
	    CON=${OUT}/connectome_tract
	    CSV1=${CON}/sub-${ID}/sub-${ID}_var-${VAR}_run-${N}_var-fcount_connectome.csv
	    CSV2=${CON}/sub-${ID}/sub-${ID}_var-${VAR}_run-${N}_var-fdensity_connectome.csv
	    CMD="initConnectome $FE $CON_LAB $CSV1 $CSV2"
	    matlab -nodesktop -nosplash -r "${ADD1};${ADD2};${CMD};exit"
	done
    done

fi


###
### Cleaning temporary files
###

if [ $STEP_CLEAN == 1 ]; then
    
    rm ${OUT}/preprocess/sub-${ID}/anat/sub-${ID}_T1w_wmmask.nii.gz
    rm -r ${OUT}/preprocess/${ID}/dti64trilin

    rm ${MIF}.mif
    rm ${MIF}.gtab
    rm ${FA}.mif
    rm ${DTI}.mif
    rm ${EV}.mif
    rm ${MIF}_sf.mif
    rm ${MIF}_wwm.mif
    rm ${ODF}.mif

fi