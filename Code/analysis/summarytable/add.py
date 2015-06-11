import os
import sys
import sqlite3
import string
import json

# read cmd arguments
if len(sys.argv) != 5:
    print 'Usage:', sys.argv[0], '<prefix> <preprocessing_type> <model_name> <imgfolder>'
    print 'Usage example: python add.py EMPTY size256 firstborn 2015-06-10-01-35'
    sys.exit(2)

# read out cmd arguments and env variables
home = os.environ['HOME']
prefix = sys.argv[1]
if prefix == 'EMPTY':
    prefix = ''
preproc = sys.argv[2]
modelname = sys.argv[3]
imgdate = sys.argv[4]

# check that all required files exist
solverfile = home + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preproc + '/' + modelname + \
             '/network_' + modelname +'_solver.prototxt'
networkfile = home + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preproc + '/' + modelname + \
             '/network_' + modelname + '.prototxt'
imgdir = home + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/' + preproc + '/' + modelname + \
             '/plots/' + imgdate
if not os.path.exists(solverfile):
    print 'Not Found:', solverfile
    exit()
if not os.path.exists(networkfile):
    print 'Not Found:', networkfile
    exit()
if not os.path.exists(imgdir):
    print 'Not Found:', imgdir
    exit()

# connect to db
dbfile = '/storage/hpc_anna/Kaggle_DRD/analysis/summarytable.db'
conn = sqlite3.connect(dbfile)
c = conn.cursor()

# prepare variables to be parsed and added to db
date = imgdate
model = modelname
dataset = preproc
lr = ''
momentum = None
decay = None
dropout = 0
imgacc = imgdir + '/accuracy.png'
imgloss = imgdir + '/loss.png'
imgwratio = imgdir + '/weight_ratios.png'
imgwmean = imgdir + '/mean_weights.png'
imgwstd = imgdir + '/stds_weights.png'
convlayers = []

# parse solver
with open(solverfile) as f:
    lines = f.readlines()
    for line in lines:
        (param, value) = [piece.strip() for piece in line.strip().split(':')]
        if param == 'base_lr':
            lr += value
        if param == 'lr_policy':
            lr += ' ' + value
        if param == 'gamma':
            lr += ' g=' + value
        if param == 'stepsize':
            lr += ' step=' + value
        if param == 'momentum':
            momentum = value
        if param == 'weight_decay':
            decay = value

# parse network description
with open(networkfile) as f:
    lines = f.readlines()
    for nr, line in enumerate(lines):

        # detect if net is using dropout
        if string.find(line, 'dropout_param') > -1:
            (param, value) = [piece.strip() for piece in line.strip().split(':')]
            dropout = value

        # build description of conv layers: [{img, numout, size, stride}, ...]
        if string.find(line, 'convolution_param') > -1:

            # parameters to parse
            numout = None
            size = None
            stride = None

            # start looking for the parameters
            brackets = 1
            linenr = nr
            while (brackets > 0):
                linenr += 1
                if string.find(lines[linenr], '{') > -1:
                    brackets += 1
                if string.find(lines[linenr], '}') > -1:
                    brackets -= 1
                try:
                    (param, value) = [piece.strip() for piece in lines[linenr].strip().split(':')]
                    if param == 'num_output':
                        numout = value
                    if param == 'kernel_size':
                        size = value
                    if param == 'stride':
                        stride = value
                except:
                    pass

            imgfile = imgdir + '/viz_conv' + str(len(convlayers) + 1) + '.png'
            convlayers.append({'img': imgfile, 'numout': numout, 'size': size, 'stride': stride})

# build the record to be added
record = (date, model, dataset, lr, momentum, decay, dropout,
          imgacc, imgloss, imgwratio, imgwmean, imgwstd, json.dumps(convlayers))

# run SQL request
c.execute('INSERT INTO summary (date, model, dataset, lr, momentum, decay, dropout, imgacc, imgloss, imgwratio,'
          'imgwmean, imgwstd, convlayers) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', record)

# save (commit) the changes
conn.commit()

# We can also close the connection if we are done with it.
# Just be sure any changes have been committed or they will be lost.
conn.close()

print 'The record has been added to the database. Now generate.py to update the HTML file.'
