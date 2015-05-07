#!/bin/bash

#INPUT=/storage/hpc_anna/Kaggle_DRD/input/raw/train
#OUTPUT=/storage/hpc_anna/Kaggle_DRD/input/trimmed/train
#
#for name in $INPUT/*.jpeg; do
#	convert $name -fuzz 3% -trim $OUTPUT/$(basename $name)
#done

INPUT=/storage/hpc_anna/Kaggle_DRD/sample_input/raw/val
OUTPUT=/storage/hpc_anna/Kaggle_DRD/sample_input/trimmed/val

find $INPUT -name "*.jpeg" -print0 | xargs -0 ls | parallel convert {} -fuzz 5% -trim $OUTPUT/{/.}.jpg

