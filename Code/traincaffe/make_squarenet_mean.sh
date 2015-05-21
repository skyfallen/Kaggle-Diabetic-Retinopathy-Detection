#!/usr/bin/env sh
# Compute the mean image from the Kaggle_DRD training lmdb
# N.B. this is available in data/ilsvrc12
#
# Usage: ./create_drdnet.sh PREFIX PREPROC
# Example: ./create_drdnet.sh "" size256
#

PREFIX=$1
PREPROC=$2

echo "Running with PREFIX="$PREFIX" and PREPROC="$PREPROC
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

CAFFEINPUT="/storage/hpc_kuz/squares/"$PREFIX"caffeinput"
IMAGES="/storage/hpc_kuz/squares/"$PREFIX"images"
TOOLS=$HOME/Software/Caffe/build/tools

echo "Removing old image mean files..."
rm $CAFFEINPUT/$PREPROC/drdnet_mean_*

echo "Computing image means..."
$TOOLS/compute_image_mean $CAFFEINPUT/$PREPROC/ilsvrc12_train_lmdb $CAFFEINPUT/$PREPROC/drdnet_mean_train.binaryproto
$TOOLS/compute_image_mean $CAFFEINPUT/$PREPROC/ilsvrc12_val_lmdb $CAFFEINPUT/$PREPROC/drdnet_mean_val.binaryproto
$TOOLS/compute_image_mean $CAFFEINPUT/$PREPROC/ilsvrc12_test_lmdb $CAFFEINPUT/$PREPROC/drdnet_mean_test.binaryproto

chmod 777 $CAFFEINPUT/$PREPROC/drdnet_mean_*

echo "Done."
