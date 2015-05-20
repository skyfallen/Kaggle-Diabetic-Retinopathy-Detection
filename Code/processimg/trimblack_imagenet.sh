#!/bin/bash
#
# Deleting black area from all images
#
# Usage: ./trimblack_imagenet.sh PREFIX SUBSET
# Example: ./trimblack_imagenet.sh "" train
#

PREFIX=$1
SUBSET=$2

echo "Running with PREFIX="$PREFIX" and SUBSET="$SUBSET
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

if [ "$SUBSET" == "train" ]; then
	cd "/storage/hpc_anna/ImageNet/"$PREFIX"images/raw/"$SUBSET
	for classdir in *; do
		if [[ -d $classdir ]]; then
			INPUT="/storage/hpc_anna/ImageNet/"$PREFIX"images/raw/"$SUBSET"/"$classdir
        		OUTPUT="/storage/hpc_anna/ImageNet/"$PREFIX"images/trimmed/"$SUBSET"/"$classdir
			mkdir $OUTPUT
        		find $INPUT -name "*.JPEG" -print0 | xargs -0 ls | parallel convert {} -fuzz 5% -trim $OUTPUT/{/.}.JPEG
		fi
	done
else
	INPUT="/storage/hpc_anna/ImageNet/"$PREFIX"images/raw/"$SUBSET
	OUTPUT="/storage/hpc_anna/ImageNet/"$PREFIX"images/trimmed/"$SUBSET
	find $INPUT -name "*.JPEG" -print0 | xargs -0 ls | parallel convert {} -fuzz 5% -trim $OUTPUT/{/.}.JPEG
fi

