#!/bin/bash

# module load nodejs
# npm install -g brainlife
# bl login

SUB=$1

RES=`bl dataset query --subject $SUB --datatype neuro/recon --tag run1 --json | jq -r ".[]._id"`
bl dataset download $RES --json | jq -r ".[]._id"
mv $RES/response.txt sub-${SUB}_response.txt
rm -r $RES

exit
