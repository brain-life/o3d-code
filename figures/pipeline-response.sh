#!/bin/bash

cd /N/dc2/projects/lifebid/Paolo/code/o3d-code/figures

DIR=src/response

declare -A sub

sub[FP]=001
sub[HT]=002
sub[KK]=003
sub[MP]=004

PRE=/N/dc2/projects/lifebid/2t1/predator/
SUF=_96dirs_b2000_1p5iso/fibers_new/run01_fliprot_aligned_trilin_response.txt

for SUB in FP HT KK MP; do
        SRC=${PRE}${SUB}${SUF}
    OUT=${DIR}/sub-${sub[$SUB]}_response.png
    if [ -f $SRC ]; then
	./plot_response.py $SRC $OUT
	echo $OUT
    fi
done


sub[105115]=005
sub[110411]=006
sub[111312]=007
sub[113619]=008

PRE=/N/dc2/projects/lifebid/2t1/HCP/
SUF=/fibers_new/dwi_data_b2000_aligned_trilin_response.txt

for SUB in 105115 110411 111312 113619; do
    SRC=${PRE}${SUB}${SUF}
    OUT=${DIR}/sub-${sub[$SUB]}_response.png
    if [ -f $SRC ]; then
	./plot_response.py $SRC $OUT
	echo $OUT
    fi
done


sub[108323]=009
sub[109123]=010
sub[131217]=011
sub[910241]=012

PRE=/N/dc2/projects/lifebid/HCP7/
SUF=/fibers/data_b2000_response.txt

for SUB in 108323 109123 131217 910241; do
    SRC=${PRE}${SUB}${SUF}
    OUT=${DIR}/sub-${sub[$SUB]}_response.png
    if [ -f $SRC ]; then
	./plot_response.py $SRC $OUT
	echo $OUT
    fi
done

