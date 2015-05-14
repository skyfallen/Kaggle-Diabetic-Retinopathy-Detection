#!/usr/bin/env sh
# Compute the mean image from the Kaggle_DRD training lmdb
# N.B. this is available in data/ilsvrc12

PREPROC=size256
CAFFEINPUT=/storage/hpc_anna/Kaggle_DRD/sample_caffeinput
IMAGES=/storage/hpc_anna/Kaggle_DRD/sample_images

TOOLS=$HOME/Software/Caffe/build/tools

$TOOLS/compute_image_mean $CAFFEINPUT/$PREPROC/ilsvrc12_train_lmdb \
  $CAFFEINPUT/$PREPROC/drdnet_mean.binaryproto

echo "Done."
