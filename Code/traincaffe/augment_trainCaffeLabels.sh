#!/bin/bash

# increase trainCaffeLabels.csv by adding modified images


cat /storage/hpc_anna/Kaggle_DRD/caffeinput/trainCaffeLabels.csv > /tmp/tmp_augmented_labels.txt
patterns_to_match=("flop_" "180_" "180_flop_180_")

for i in ${patterns_to_match[@]}; 
do 
    #echo "cat '/storage/hpc_anna/Kaggle_DRD/caffeinput/trainCaffeLabels.csv' | sed 's/^/$i/g' >> '/tmp/tmp_augmented_labels.txt'"
    cat /storage/hpc_anna/Kaggle_DRD/caffeinput/trainCaffeLabels.csv | sed s/^/"$i"/g >> /tmp/tmp_augmented_labels.txt  
done

cat /tmp/tmp_augmented_labels.txt > /storage/hpc_anna/Kaggle_DRD/caffeinput/trainCaffeLabels.csv 
rm /tmp/tmp_augmented_labels.txt 

