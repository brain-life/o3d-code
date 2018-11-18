#!/bin/bash

# module load nodejs
# npm install -g brainlife
# bl login

SUB=$1

DWI=`bl dataset query --subject $SUB --tag b2000 --json | jq -r ".[]._id"`
APP=`bl app query --doi 10.25663/brainlife.app.120 --json | jq -r ".[]._id"`
PRJ=5a022fc99c0d250055709e9c
JOB=`bl app run --id $APP --input dwi:$DWI --project $PRJ --json | jq -r "._id"`
bl app wait --id $JOB
RES=`bl dataset query --taskid $JOB --json | jq -r ".[]._id"`
OUT=`bl dataset download $RES --json | jq -r ".[]._id"`
mv $RES/product.json sub-${SUB}_snr.json
rm -r $RES

exit
