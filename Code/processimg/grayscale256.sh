#!/bin/bash

#
# From RGB to Gray scale
#
# Usage: ./grayscale256.sh PREFIX PREPROC SUBSET
# Example: ./grayscale256.sh "" size256 train
#

PREFIX=$1
PREPROC=$2
SUBSET=$3

echo "Running with PREFIX="$PREFIX", PREPROC="$PREPROC" and SUBSET="$SUBSET
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

INPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/"$SUBSET

mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/gr"$PREPROC
chmod 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/gr"$PREPROC
mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/gr"$PREPROC"/"$SUBSET
chmod 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/gr"$PREPROC"/"$SUBSET

OUTPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/gr"$PREPROC"/"$SUBSET

find $INPUT -name "*.jpg" -print0 | xargs -0 ls | parallel convert {} -set colorspace Gray -separate -average $OUTPUT/{/.}.jpg

