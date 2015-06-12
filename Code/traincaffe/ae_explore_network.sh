#!/bin/bash

#
# Extract network activations when run on test or validation data
#
# Usage: ./ae_explore_network.sh PREFIX PREPROC MODELNAME
# Example: ./ae_explore_network.sh "" size256 basic
#

PREFIX=$1
PREPROC=$2
MODELNAME=$3

echo "Running with PREFIX="$PREFIX" PREPROC="$PREPROC" MODELNAME="$MODELNAME
read -n1 -r -p "Is it OK? (any key if yes, ^C if no)" key

cat "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt" | grep "Train net output #0: cross_entropy_loss" | awk '{ print $11 }' > "/tmp/"$USER"_plot_train_crossent.txt"
cat "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt" | grep "Train net output #1: l2_error =" | awk '{ print $11 }' > "/tmp/"$USER"_plot_train_l2error.txt"
cat "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt" | grep "Test net output #0: cross_entropy_loss" | awk '{ print $11 }' > "/tmp/"$USER"_plot_test_crossent.txt"
cat "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/"$PREPROC"/model_"$MODELNAME"/log.txt" | grep "Test net output #1: l2_error =" | awk '{ print $11 }' > "/tmp/"$USER"_plot_test_l2error.txt"

CURDATE=$(date +%Y-%m-%d-%H-%M)
mkdir $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/"$PREPROC"/"$PREFIX$MODELNAME"/plots"
mkdir $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/"$PREPROC"/"$PREFIX$MODELNAME"/plots/"$CURDATE

if [ "$PREFIX" == "" ]; then
	python $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/ae_plot_accuracy_loss.py" EMPTY $PREPROC $MODELNAME $CURDATE
	python $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/ae_plot_weight_stats.py" EMPTY $PREPROC $MODELNAME $CURDATE
else
	python $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/ae_plot_accuracy_loss.py" $PREFIX $PREPROC $MODELNAME $CURDATE
	python $HOME"/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/ae_plot_weight_stats.py" $PREFIX $PREPROC $MODELNAME $CURDATE
fi

# wait a bit and remove temp files
sleep 2
rm "/tmp/"$USER"_plot_train_crossent.txt"
rm "/tmp/"$USER"_plot_train_l2error.txt"
rm "/tmp/"$USER"_plot_test_crossent.txt"
rm "/tmp/"$USER"_plot_test_l2error.txt"

echo "Done."
