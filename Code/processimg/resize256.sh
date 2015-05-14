#!/bin/bash

#
# Resizing images
#
# Usage: ./resize256.sh PREFIX SUBSET
# Example: ./resize256.sh "" train
#

PREFIX=$1
SUBSET=$2

echo "Running with PREFIX="$PREFIX" and SUBSET="$SUBSET
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

INPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/trimmed/"$SUBSET
OUTPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/size256/"$SUBSET

find $INPUT -name "*.jpg" -print0 | xargs -0 ls | parallel convert {} -resize 256x256 -background black -gravity center -extent 256x256 $OUTPUT/{/.}.jpg

