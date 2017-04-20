#!/bin/bash

#PBS -k o 
#PBS -l nodes=1:ppn=2,mem=4000mb,walltime=24:00:00 
#PBS -M pavesani@iu.edu
#PBS -m abe
#PBS -N hcp7t-redo
#PBS -j oe

# Adaptation of the original pipeline used for Caiafa-Pestilli paper
# see on github.com the repository
# brain-life/pestillilab_projects/blob/master/et/mrtrix_ensemble_7t.sh

ID_0009=108323
ID_0010=109123
ID_0011=131217
ID_0012=910241

SUB=$1
ID=$(eval echo "\$ID_$1")

SRC=/N/dc2/projects/lifebid/HCP7/${ID}/fibers
DIR=/N/dc2/projects/o3d/test3/O3D_HCP7T/derivatives/preprocess/sub-${SUB}/dwi

OUT=/N/dc2/projects/lifebid/Paolo/data/O3D_SRC/HCP7T/${ID}
DWI=data_b2000

LMAX=8
NUMFIBERS=500000
MAXNUMFIBERSATTEMPTED=1500000

cp ${SRC}/${DWI}_wm.mif ${OUT}/${DWI}_wm.mif

## create eigenvector map
tensor2vector $OUT/${DWI}_dt.mif - | \
    mrmult - $OUT/${DWI}_fa.mif $OUT/${DWI}_ev.mif

## Perform CSD in white matter voxel
csdeconv $OUT/${DWI}_dwi.mif \
    -grad $OUT/$DWI.b \
    $OUT/${DWI}_response.txt \
    -lmax $LMAX \
    -mask $OUT/${DWI}_brainmask.mif \
    $OUT/${DWI}_lmax${LMAX}.mif

##echo tracking Deterministic Tensorbased
for i_track in 01 02 03 04 05 06 07 08 09 10; do
    streamtrack DT_STREAM $OUT/${DWI}_dwi.mif \
	$OUT/${DWI}_wm_tensor-NUM${i_track}-$NUMFIBERS.tck \
	-seed $OUT/${DWI}_wm.mif \
	-mask $OUT/${DWI}_wm.mif \
	-grad $OUT/${DWI}.b \
	-number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
done

for i_track in 01 02 03 04 05 06 07 08 09 10; do
    for i_type in SD_STREAM SD_PROB; do
	streamtrack $i_type $OUT/${DWI}_lmax${LMAX}.mif \
	    $OUT/${DWI}_csd_lmax${LMAX}_wm_${i_type}-NUM${i_track}-$NUMFIBERS.tck \
	    -seed $OUT/${DWI}_wm.mif \
	    -mask $OUT/${DWI}_wm.mif \
	    -grad $OUT/$DWI.b \
	    -number $NUMFIBERS -maxnum $MAXNUMFIBERSATTEMPTED
    done
done