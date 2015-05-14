#!/bin/bash

#
# Creates file with image names	and zeros instead of labels for	test
#

PREFIX='sample_'
PREPROC='size256'

cd "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"images/"$PREPROC"/test"
ls * | sed 's/$/ 0/' > "/storage/hpc_anna/Kaggle_DRD/"$PREFIX"caffeinput/test.txt"


