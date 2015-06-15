#!/bin/bash

PREFIX=$1
PREPROC=$2
MODELNAME=$3

#echo "Running with PREFIX="$PREFIX" PREPROC="$PREPROC" MODELNAME="$MODELNAME
#read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

if [ "$PREFIX" == "EMPTY" ]; then
	PREFIX=""
fi

srun --partition=gpu --gres=gpu:1 --constraint=K20 --mem=40000 $HOME"/Software/Caffe/build/tools/caffe" train --solver=$HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/"$PREPROC"/"$PREFIX$MODELNAME"/network_"$MODELNAME"_solver.prototxt"

