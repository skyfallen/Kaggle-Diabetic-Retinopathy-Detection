#!/bin/bash

INPUT=/storage/hpc_anna/Kaggle_DRD/input/raw/train
OUTPUT=/storage/hpc_anna/Kaggle_DRD/input/size256/train

find $INPUT -name "*.jpeg" -print0 | xargs -0 ls | parallel convert {} -resize 256x256 $OUTPUT/{/.}.jpg

