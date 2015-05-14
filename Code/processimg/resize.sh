#
# Resizing images
#

#!/bin/bash

INPUT=/storage/hpc_anna/Kaggle_DRD/sample_images/trimmed/test
OUTPUT=/storage/hpc_anna/Kaggle_DRD/sample_images/size256/test

find $INPUT -name "*.jpg" -print0 | xargs -0 ls | parallel convert {} -resize 256x256 -background black -gravity center -extent 256x256 $OUTPUT/{/.}.jpg

