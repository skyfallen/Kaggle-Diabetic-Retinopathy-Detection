#### Lists of images
First you need to produce `train.txt`, `val.txt` and `test.txt`. These files indicate which files will go for training, validation and test phases. To create those files run
* `Code/traincaffe/make_drdnet_train_labels.sh`
* `Code/traincaffe/make_drdnet_val_labels.sh`
* `Code/traincaffe/make_drdnet_test_labels.sh`


#### Create LMDB from images for Caffe
Run `Code/traincaffe/create_drdnet.sh`


#### Compute image means
Caffe needs it for some reason  
Run `Code/traincaffe/make_drdnet_mean.sh`


#### Prepare .prototxt files
##### Training and validation
Describe your network (for examples `Code/traincaffe/networks/network_basic.prototxt`)  
* Training parameters
  * In `data` layer for `TRAIN` phase set `transform_param -> mean_file` to point at `caffeinput/PREPROC/drdnet_mean_train.binaryproto`  
  * In `data` layer for `TRAIN` phase set `data_param -> source` to point at `caffeinput/PREPROC/ilsvrc12_train_lmdb`  
* Validation parameters
  * In `data` layer for `TEST` phase set `transform_param -> mean_file` to point at `caffeinput/PREPROC/drdnet_mean_val.binaryproto`
  * In `data` layer for `TEST` phase set `data_param -> source` to point at `caffeinput/PREPROC/ilsvrc12_val_lmdb`  

where `PREPROC` is the preprocessing type (for example `size256`)

##### Solver
`solver.prototxt` lists training parameters.  
Set `net:` to point at the network structure description for training and validation(for exampe `Code/traincaffe/networks/network_basic.prototxt`).  
Set `snapshot_prefix:` to point at the location to store trained model(s).  
Think about all the other parameters you see in there.

##### Testing


#### Train 
```./build/tools/caffe train --solver=models/bvlc_reference_caffenet/solver.prototxt```
