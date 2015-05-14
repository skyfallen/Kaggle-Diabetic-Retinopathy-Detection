#### Stucture

Images are stored at `/storage/hpc_anna/Kaggle_DRD/images` (`samples_images` for sample dataset)
substructure goes as
* `raw`
  * `train`
  * `val`
  * `test`
* `trimmed`
  * ...
* `size256`
  * ...

#### Generate samples images

Run scripts from`Code/preparedata/sample*.sh`

#### Trim images

Next we remove "boring" black background surrounding the picture of the retina. This can be done with the `Code/processimg/trimblack.sh` script. You need to manually change [ train | val | test ] inside the scripts to process the corresponding subset.

#### Resize images

The original images have sizes of order of 4000x3000 pixel. It is not feasible to train them using ANN so we resize them. This can be done using `Code/processimg/resize.sh`. You need to manually change [ train | val | test ] inside the scripts to process the corresponding subset.

#### The next step is ...
Once you have the images go to `Code/traincaffe` to shape them for caffe
