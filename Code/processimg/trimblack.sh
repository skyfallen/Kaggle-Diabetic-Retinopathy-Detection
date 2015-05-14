#!/bin/bash
#
# Deleting black area from all images
#

PREFIX=''

INPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/raw/val"
OUTPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/trimmed/val"

find $INPUT -name "*.jpeg" -print0 | xargs -0 ls | parallel convert {} -fuzz 5% -trim $OUTPUT/{/.}.jpg

