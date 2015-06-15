#!/bin/bash

#
# Extract network activations when run on test or validation data
#
# Usage: ./test_drdnet.sh PREFIX PREPROC MODELNAME SUBSET
# Example: ./test_drdnet.sh "" size256 basic test 
#

PREFIX=$1
PREPROC=$2
MODELNAME=$3
NITER=$4
SUBSET=$5
NSAMPLES=$(ls "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/"$SUBSET"/" | wc -l)

echo "Running with PREFIX="$PREFIX" PREPROC="$PREPROC" MODELNAME="$MODELNAME" NITER="$NITER" SUBSET="$SUBSET" and NSAMPLES="$NSAMPLES
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

# create output directories
mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC
chmod 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC
mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/model_"$MODELNAME
chmod 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/model_"$MODELNAME
mkdir "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/model_"$MODELNAME"/reconstructed"
chmod 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/model_"$MODELNAME"/reconstructed"

# remove previous results
rm -rf "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET

# extract
#srun --partition=gpu --gres=gpu:1 --constraint=K20 --mem=20000 \
$HOME"/Software/Caffe/build/tools/extract_features.bin" "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/model_iter_"$NITER".caffemodel" \
$HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/"$PREPROC"/"$PREFIX$MODELNAME"/network_"$MODELNAME"_"$SUBSET".prototxt" \
reconstruct \
"/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET $NSAMPLES lmdb GPU 0

# wait until features folder is stored to the hard drive
echo "Sleeping ..."
sleep 60

# change permissions to the extracted features
chmod -R 777 "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"features/"$PREPROC"/features_"$MODELNAME"_"$SUBSET

# extract labels from LMDB
source ~/Python/bin/activate
if [ "$PREFIX" == "" ]; then
	python $HOME/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/ae_lmdb2reconstructed_img.py EMPTY $PREPROC $MODELNAME $SUBSET
else
	python $HOME/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/ae_lmdb2reconstructed_img.py $PREFIX $PREPROC $MODELNAME $SUBSET
fi

