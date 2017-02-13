#!/bin/bash

ID_0009=108323
ID_0010=109123
ID_0011=131217
ID_0012=910241

SUB=$1
ID=$(eval echo "\$ID_$1")

DIR=/N/dc2/projects/o3d/test3/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/dwi
SRC=${DIR}/sub-${SUB}

OUT=/N/dc2/projects/lifebid/Paolo/data/O3D_SRC/HCP7T/${ID}
MIF=data_b2000

mrconvert ${SRC}_dwi_brainmask.nii.gz ${OUT}/${MIF}_brainmask.mif
mrconvert ${SRC}_b-2000_dwi.nii.gz ${OUT}/${MIF}_dwi.mif

sed 's/,/\ /g' ${SRC}_b-2000_dwi.bvecs > ${OUT}/bvecs
sed 's/,/\ /g' ${SRC}_b-2000_dwi.bvals > ${OUT}/bvals

/N/dc2/projects/o3d/code/utils/bvecT.sh ${OUT}/bvecs > ${OUT}/${MIF}.bvecsT
/N/dc2/projects/o3d/code/utils/bvecT.sh ${OUT}/bvals > ${OUT}/${MIF}.bvalsT
paste ${OUT}/${MIF}.bvecsT ${OUT}/${MIF}.bvalsT > ${OUT}/${MIF}.b
rm ${OUT}/${MIF}.bvecsT ${OUT}/${MIF}.bvalsT ${OUT}/bvecs ${OUT}/bvals

dwi2tensor ${OUT}/${MIF}_dwi.mif -grad ${OUT}/${MIF}.b ${OUT}/${MIF}_dt.mif
tensor2FA ${OUT}/${MIF}_dt.mif - | mrmult - ${OUT}/${MIF}_brainmask.mif ${OUT}/${MIF}_fa.mif
erode ${OUT}/${MIF}_brainmask.mif -npass 3 - | mrmult ${OUT}/${MIF}_fa.mif - - | threshold - -abs 0.7 ${OUT}/${MIF}_sf.mif

estimate_response ${OUT}/${MIF}_dwi.mif ${OUT}/${MIF}_sf.mif -lmax 6 -grad ${OUT}/${MIF}.b ${OUT}/${MIF}_response.txt
