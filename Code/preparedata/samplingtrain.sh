ls  /storage/hpc_anna/Kaggle_DRD/input/raw/train |sort -R |tail -n 80 |while read file; do
	cp  /storage/hpc_anna/Kaggle_DRD/input/raw/train/$file /storage/hpc_anna/Kaggle_DRD/sample_input/raw/train
	#echo "/storage/hpc_anna/Kaggle_DRD/input/raw/train/$file /storage/hpc_anna/Kaggle_DRD/sample_input/raw/train"
done
