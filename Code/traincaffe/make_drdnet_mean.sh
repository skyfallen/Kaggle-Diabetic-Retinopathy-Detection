#!/usr/bin/env sh
# Compute the mean image from the Kaggle_DRD training lmdb
# N.B. this is available in data/ilsvrc12

PREFIX="sample_"
PREPROC=size256
CAFFEINPUT="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput"
IMAGES="/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images"

TOOLS=$HOME/Software/Caffe/build/tools

$TOOLS/compute_image_mean $CAFFEINPUT/$PREPROC/ilsvrc12_train_lmdb $CAFFEINPUT/$PREPROC/drdnet_mean_train.binaryproto
$TOOLS/compute_image_mean $CAFFEINPUT/$PREPROC/ilsvrc12_val_lmdb $CAFFEINPUT/$PREPROC/drdnet_mean_val.binaryproto
$TOOLS/compute_image_mean $CAFFEINPUT/$PREPROC/ilsvrc12_test_lmdb $CAFFEINPUT/$PREPROC/drdnet_mean_test.binaryproto

chmod 777 $CAFFEINPUT/$PREPROC/drdnet_mean_*

echo "Done."
