#!/bin/sh

OUT=/N/dc2/projects/o3d/data
SRC=/N/dc2/projects/o3d/code/metadata

cp $SRC/readme_main.txt \
    $OUT/README
cp $SRC/CHANGES \
    $OUT/CHANGES
cp $SRC/LICENSE \
    $OUT/LICENSE
cp $SRC/participants.tsv \
    $OUT/participants.tsv

cp $SRC/readme_preprocess.txt \
    $OUT/derivatives/preprocess/README

cp $SRC/readme_recon.txt \
    $OUT/derivatives/recon_models/README

cp $SRC/readme_dtidet.txt \
    $OUT/derivatives/tracking_dtidet_tck/README
cp $SRC/readme_dtidet.txt \
    $OUT/derivatives/tracking_dtidet_trk/README
cp $SRC/readme_csddet.txt \
    $OUT/derivatives/tracking_csddet_tck/README
cp $SRC/readme_csddet.txt \
    $OUT/derivatives/tracking_csddet_trk/README
cp $SRC/readme_csdprob.txt \
    $OUT/derivatives/tracking_csdprob_tck/README
cp $SRC/readme_csdprob.txt \
    $OUT/derivatives/tracking_csdprob_trk/README

cp $SRC/readme_dissection.txt \
    $OUT/derivatives/dissection_afq_dtidet_tck/README
cp $SRC/readme_dissection.txt \
    $OUT/derivatives/dissection_afq_dtidet_trk/README
cp $SRC/readme_dissection.txt \
    $OUT/derivatives/dissection_afq_csddet_tck/README
cp $SRC/readme_dissection.txt \
    $OUT/derivatives/dissection_afq_csddet_trk/README
cp $SRC/readme_dissection.txt \
    $OUT/derivatives/dissection_afq_csdprob_tck/README
cp $SRC/readme_dissection.txt \
    $OUT/derivatives/dissection_afq_csdprob_trk/README

cp $SRC/readme_connectome.txt \
    $OUT/derivatives/connectome_tract/README

cp -r $SRC/input \
    $OUT/input

cp $SRC/T1w_dtissue.json \
    $OUT/derivatives/preprocess/anat/T1w_dtissue.json