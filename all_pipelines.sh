#!/bin/bash

#PBS -k o 
#PBS -l nodes=1:ppn=2,mem=4000mb,walltime=8:00:00 
#PBS -M pavesani@iu.edu
#PBS -m abe
#PBS -N o3d-gen-sub
#PBS -j oe

dataset=$1
subject=$2
root=$3

cd /N/dc2/projects/o3d/code

JOB1=`python init_connectome_tract.py $dataset $subject $root &`
JOB2=`python init_preprocessing.py $dataset $subject $root &`
JOB3=`python init_recon_models.py $dataset $subject $root &`
JOB4=`python init_tracking_csddet_trk.py $dataset $subject $root &`
JOB5=`python init_tracking_csdprob_trk.py $dataset $subject $root &`
JOB6=`python init_tracking_dtidet_trk.py $dataset $subject $root &`
JOB7=`python init_dissection_afq_trk.py $dataset $subject $root &`
wait $JOB1 $JOB2 $JOB3 $JOB4 $JOB5 $JOB6 
python init_tracking_csddet_tck.py $dataset $subject $root &
python init_tracking_csdprob_tck.py $dataset $subject $root &
python init_tracking_dtidet_tck.py $dataset $subject $root &
python init_dissection_afq_trk.py $dataset $subject $root &

