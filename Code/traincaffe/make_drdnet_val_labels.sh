#!/bin/bash

#
# Creates file with image names and  labels for validation
#

PREFIX='sample_'
PREPROC='size256'

cd "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/val"
ls * | sed 's/^/\^/g' > ../val_files.txt
egrep -f "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/val_files.txt" "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/trainCaffeLables.csv" > "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/val.txt"
rm "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/val_files.txt"

