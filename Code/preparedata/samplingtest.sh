ls  /storage/hpc_anna/Kaggle_DRD/input/raw/test |sort -R |tail -n 110 |while read file; do
	cp  /storage/hpc_anna/Kaggle_DRD/input/raw/test/$file /storage/hpc_anna/Kaggle_DRD/sample_input/raw/test
	#echo "/storage/hpc_anna/Kaggle_DRD/input/raw/test/$file /storage/hpc_anna/Kaggle_DRD/sample_input/raw/test"
done
