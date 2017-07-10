#!/bin/bash

VAR=$1

SUB='0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012'

if [ $VAR == length ]; then
    echo PLOT TRACKING
    for S in $SUB; do
	PNG=/N/dc2/projects/o3d/doc/figures/tracking-plot/sub-${S}_tracking_plot.eps
	/N/dc2/projects/o3d/code/figures/plot_tract_length.py ${S} ${PNG}
	echo plot sub-$S
    done
fi


SUB='0001 0002 0003 0004 0005 0006 0007 0008'

if [ $VAR == afq ]; then
    ECHO PLOT AFQ
    for S in $SUB; do
	PNG=/N/dc2/projects/o3d/doc/figures/afq-stat/sub-${S}_afq_plot.eps
	/N/dc2/projects/o3d/code/figures/plot_afq_stat.py ${S} ${PNG}
	echo plot sub-$S
    done
fi


SUB='0001 0002 0003 0004 0005 0006 0007 0008'

if [ $VAR == tract ]; then
    ECHO PLOT AFQ
    for S in $SUB; do
	for T in dtidet csddet csdprob; do
	    PNG=/N/dc2/projects/o3d/doc/figures/afq-plot/sub-${S}_${T}_plot.png
	    /N/dc2/projects/o3d/code/figures/plot_tract_sub.py ${S} -png ${PNG} -var $T
	    echo plot sub-$S
	done
    done
fi