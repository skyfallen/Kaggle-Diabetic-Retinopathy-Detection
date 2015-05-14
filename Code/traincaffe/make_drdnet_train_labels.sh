#!/bin/bash

#
# Creates file with image names and labels for train
#

PREFIX='sample_'
PREPROC='size256'

cd "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/train"
ls * | sed 's/^/\^/g' > ../train_files.txt
egrep -f "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/train_files.txt" "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/trainCaffeLables.csv" > "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/train.txt"
rm "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/train_files.txt"
