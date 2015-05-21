
#!/usr/bin/env sh

# Create the Kaggle competition lmdb inputs
# N.B. set the path to the KAggle_DRD train + val data dirs
#
# Usage: ./create_imagenet.sh PREFIX PREPROC
# Example: ./create_imagenet.sh "" size256
#

PREFIX=$1
PREPROC=$2

echo "Running with PREFIX="$PREFIX" and PREPROC="$PREPROC
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

CAFFEINPUT="/storage/hpc_anna/ImageNet/"$PREFIX"caffeinput"
IMAGES="/storage/hpc_anna/ImageNet/"$PREFIX"images"
TOOLS=$HOME/Software/Caffe/build/tools

TRAIN_DATA_ROOT=$IMAGES/$PREPROC/train
VAL_DATA_ROOT=$IMAGES/$PREPROC/val
TEST_DATA_ROOT=$IMAGES/$PREPROC/test

# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=false
if $RESIZE; then
  RESIZE_HEIGHT=256
  RESIZE_WIDTH=256
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

if [ ! -d "$TRAIN_DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet training data is stored."
  exit 1
fi

if [ ! -d "$VAL_DATA_ROOT" ]; then
  echo "Error: VAL_DATA_ROOT is not a path to a directory: $VAL_DATA_ROOT"
  echo "Set the VAL_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet validation data is stored."
  exit 1
fi

if [ ! -d "$TEST_DATA_ROOT" ]; then
  echo "Error: TEST_DATA_ROOT is not a path to a directory: $TEST_DATA_ROOT"
  echo "Set the TEST_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet validation data is stored."
  exit 1
fi

echo "Removing old lmdb files..."

rm -rf $CAFFEINPUT/$PREPROC/ilsvrc12_*

echo "Creating train lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle \
    $TRAIN_DATA_ROOT/ \
    $CAFFEINPUT/train.txt \
    $CAFFEINPUT/$PREPROC/ilsvrc12_train_lmdb

echo "Creating val lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle \
    $VAL_DATA_ROOT/ \
    $CAFFEINPUT/val.txt \
    $CAFFEINPUT/$PREPROC/ilsvrc12_val_lmdb

echo "Creating test lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $TEST_DATA_ROOT/ \
    $CAFFEINPUT/test.txt \
    $CAFFEINPUT/$PREPROC/ilsvrc12_test_lmdb

chmod -R 777 $CAFFEINPUT/$PREPROC/ilsvrc12_*

echo "Done."
