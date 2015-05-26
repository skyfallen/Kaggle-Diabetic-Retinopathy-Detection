#!/bin/bash
#
# Increase number of images by mirroring and rotating
#
# Usage: ./augmentdataset.sh PREFIX
# Example: ./augmentdataset.sh ""
#

PREFIX=$1

echo "Running with PREFIX="$PREFIX
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

INPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/size256/trainval"
OUTPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/augm256/trainval"

mkdir $OUTPUT"/train_180"
mkdir $OUTPUT"/train_flop"
mkdir $OUTPUT"/train_180_flop"

for f in `find $INPUT -name "*.jpg"`
do
  #echo $OUTPUT"/train_180/180_"$(basename $f)
  convert $f -rotate 180 $OUTPUT"/train_180/180_"$(basename $f)
done

for f in `find $INPUT -name "*.jpg"`
do
#  echo $f
  convert $f -flop $OUTPUT"/train_flop/flop_"$(basename $f)
done

for f in `find $OUTPUT"/train_180" -name "*.jpg"`
do
  #echo $f
  convert $f -flop $OUTPUT"/train_180_flop/180_flop_"$(basename $f)
done

