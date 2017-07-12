#!/bin/bash

WRD=$(head -n 1 $1|wc -w);
for((i=1;i<=$WRD;i++)); do
    awk '{print $'$i'}' $1| tr '\n' ' ';echo;
done
