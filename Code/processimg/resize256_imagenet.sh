#!/bin/bash
#
# Resize ImageNet files
#
# Usage: ./resize256_imagenet.sh PREFIX SUBSET
# Example: ./resize256_imagenet.sh "" train
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
        		OUTPUT="/storage/hpc_anna/ImageNet/"$PREFIX"images/size256/"$SUBSET"/"$classdir
			mkdir $OUTPUT
			find $INPUT -name "*.JPEG" -print0 | xargs -0 ls | parallel convert {} -resize 256x256\! $OUTPUT/{/.}.JPEG
		fi
	done
else
	INPUT="/storage/hpc_anna/ImageNet/"$PREFIX"images/raw/"$SUBSET
	OUTPUT="/storage/hpc_anna/ImageNet/"$PREFIX"images/size256/"$SUBSET
	find $INPUT -name "*.JPEG" -print0 | xargs -0 ls | parallel convert {} -resize 256x256\! $OUTPUT/{/.}.JPEG
fi

