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

mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC
cd "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/"$SUBSET
if [ "$SUBSET" != "test" ]; then
	find . -name '*.jpg'| sed 's/^\.\//\^/g' > "/tmp/"$PREPROC"_temp_"$SUBSET"_labels.txt"
	touch "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/"$SUBSET".txt"
	while read line
	do
		grep -e $line "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/trainCaffeLabels.csv" >> "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/"$SUBSET".txt"
	done < "/tmp/temp_"$SUBSET"_labels.txt"
	rm "/tmp/temp_"$SUBSET"_labels.txt"
else
	find . -name '*.jpg' | sed 's/^\.\///g' | sed 's/$/ 0/' > "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/test.txt"
fi
