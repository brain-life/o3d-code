#!/bin/bash

BVEC=$1
BVAL=$2
GTAB=$3

SRC=/N/dc2/projects/o3d/code/utils
$SRC/bvecT.sh $BVEC > /tmp/_bvecT
$SRC/bvecT.sh $BVAL > /tmp/_bvalT
paste /tmp/_bvecT /tmp/_bvalT > $GTAB
rm /tmp/_bvecT /tmp/_bvalT

# If values are comma separated
#sed 's/,/\ /g' ${SRC}_b-2000_dwi.bvecs > ${OUT}/bvecs
#sed 's/,/\ /g' ${SRC}_b-2000_dwi.bvals > ${OUT}/bvals
