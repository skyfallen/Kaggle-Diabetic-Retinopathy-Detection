#!/bin/bash

#
# Resizing images
#
# Usage: ./resize64.sh PREFIX SUBSET
# Example: ./resize64.sh "" train
#

PREFIX=$1
SUBSET=$2

echo "Running with PREFIX="$PREFIX" and SUBSET="$SUBSET
#read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

INPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/trimmed/"$SUBSET
OUTPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/size64/"$SUBSET

find $INPUT -name "*.jpg" -print0 | xargs -0 ls | parallel convert {} -resize 64x64 -background black -gravity center -extent 64x64 $OUTPUT/{/.}.jpg

