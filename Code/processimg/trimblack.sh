#!/bin/bash
#
# Deleting black area from all images
#

INPUT=/storage/hpc_anna/Kaggle_DRD/sample_images/raw/test
OUTPUT=/storage/hpc_anna/Kaggle_DRD/sample_images/trimmed/test

find $INPUT -name "*.jpeg" -print0 | xargs -0 ls | parallel convert {} -fuzz 5% -trim $OUTPUT/{/.}.jpg

