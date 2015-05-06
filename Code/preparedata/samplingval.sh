ls  /storage/hpc_anna/Kaggle_DRD/input/raw/val |sort -R |tail -n 20 |while read file; do
	cp  /storage/hpc_anna/Kaggle_DRD/input/raw/val/$file /storage/hpc_anna/Kaggle_DRD/sample_input/raw/val
	#echo "/storage/hpc_anna/Kaggle_DRD/input/raw/val/$file /storage/hpc_anna/Kaggle_DRD/sample_input/raw/val"
done
