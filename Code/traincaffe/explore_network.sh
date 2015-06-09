#!/bin/bash

#
# Extract network activations when run on test or validation data
#
# Usage: ./explore_network.sh PREFIX PREPROC MODELNAME
# Example: ./explore_network.sh "" size256 basic
#

PREFIX=$1
PREPROC=$2
MODELNAME=$3

echo "Running with PREFIX="$PREFIX" PREPROC="$PREPROC" MODELNAME="$MODELNAME
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

cat "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt" | grep "Train net output #0: accuracy_TRAIN" | awk '{ print $11 }' > "/tmp/"$USER"_plot_train_acc.txt"
cat "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt" | grep "Train net output #1: loss =" | awk '{ print $11 }' > "/tmp/"$USER"_plot_train_loss.txt"
cat "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt" | grep "Test net output #0: accuracy_TEST" | awk '{ print $11 }' > "/tmp/"$USER"_plot_test_acc.txt"
cat "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt" | grep "Test net output #1: loss =" | awk '{ print $11 }' > "/tmp/"$USER"_plot_test_loss.txt"

mkdir $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/"$PREPROC"/"$PREFIX$MODELNAME"/plots"
if [ "$PREFIX" == "" ]; then
	python $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/plot_accuracy_loss.py" EMPTY $PREPROC $MODELNAME
	python $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/plot_weight_stats.py" EMPTY $PREPROC $MODELNAME
else
	python $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/plot_accuracy_loss.py" $PREFIX $PREPROC $MODELNAME
	python $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/plot_weight_stats.py" $PREFIX $PREPROC $MODELNAME
fi

# wait a bit and remove temp files
sleep 2
rm "/tmp/"$USER"_plot_train_acc.txt"
rm "/tmp/"$USER"_plot_train_loss.txt"
rm "/tmp/"$USER"_plot_test_acc.txt"
rm "/tmp/"$USER"_plot_test_loss.txt"

echo "Done."
