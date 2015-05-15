#!/bin/bash

#
# Creates file with image names and labels for training
# 
# Usage: ./make_drdnet_labels.sh PREFIX PREPROC SUBSET
# Example: ./make_drdnet_labels.sh "" size256 train
#

PREFIX=$1
PREPROC=$2
SUBSET=$3

echo "Running with PREFIX="$PREFIX", PREPROC="$PREPROC" and SUBSET="$SUBSET
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

cd "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/"$SUBSET
if [ "$SUBSET" != "test" ]; then
	ls * | sed 's/^/\^/g' > ../temp_labels.txt
	egrep -f "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/temp_labels.txt" "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/trainCaffeLables.csv" > "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$SUBSET".txt"
	rm "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/temp_labels.txt"
else
	ls * | sed 's/$/ 0/' > "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/test.txt"
fi
