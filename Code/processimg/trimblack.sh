#!/bin/bash
#
# Deleting black area from all images
#
# Usage: ./trimblack.sh PREFIX SUBSET
# Example: ./trimblack.sh "" train
#

PREFIX=$1
SUBSET=$2

echo "Running with PREFIX="$PREFIX" and SUBSET="$SUBSET
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

PREFIX=''

INPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/raw/"$SUBSET
OUTPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/trimmed/"$SUBSET

find $INPUT -name "*.jpeg" -print0 | xargs -0 ls | parallel convert {} -fuzz 5% -trim $OUTPUT/{/.}.jpg

