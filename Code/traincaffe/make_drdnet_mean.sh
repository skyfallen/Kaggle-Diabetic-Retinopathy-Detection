#!/usr/bin/env sh
# Compute the mean image from the imagenet training lmdb
# N.B. this is available in data/ilsvrc12

PREPROC=size256
LMDB=/storage/hpc_anna/Kaggle_DRD/sample_lmdb
INPUT=/storage/hpc_anna/Kaggle_DRD/sample_input

TOOLS=$HOME/Software/Caffe/build/tools

$TOOLS/compute_image_mean $OUTPUT/$PREPROC/ilsvrc12_train_lmdb \
  $INPUT/$PREPROC/drdnet_mean.binaryproto

echo "Done."
