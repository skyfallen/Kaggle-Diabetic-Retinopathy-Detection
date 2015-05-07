#!/bin/bash
cd /storage/hpc_anna/Kaggle_DRD/sample_input/size256/test
ls * | sed 's/$/ 0/' > ../test.txt


