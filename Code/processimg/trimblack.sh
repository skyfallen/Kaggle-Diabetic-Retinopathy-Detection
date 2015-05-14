#!/bin/bash
#
# Deleting black area from all images
#

#INPUT=/storage/hpc_anna/Kaggle_DRD/images/raw/train
#OUTPUT=/storage/hpc_anna/Kaggle_DRD/images/trimmed/train
#
#for name in $INPUT/*.jpeg; do
#	convert $name -fuzz 3% -trim $OUTPUT/$(basename $name)
#done

INPUT=/storage/hpc_anna/Kaggle_DRD/sample_images/raw/val
OUTPUT=/storage/hpc_anna/Kaggle_DRD/sample_images/trimmed/val

find $INPUT -name "*.jpeg" -print0 | xargs -0 ls | parallel convert {} -fuzz 5% -trim $OUTPUT/{/.}.jpg

