import os
import sqlite3
import json

# variables
home = os.environ['HOME']

# connect to db
dbfile = '/storage/hpc_anna/Kaggle_DRD/analysis/summarytable.db'
conn = sqlite3.connect(dbfile)
c = conn.cursor()

# update HTML
outhtml = home + '/Kaggle/Diabetic-Retinopathy-Detection/Code/traincaffe/networks/README.html'
indir = home + '/Kaggle/Diabetic-Retinopathy-Detection/Code/analysis/summarytable'
header = open(indir + '/header.html').read()
footer = open(indir + '/footer.html').read()
with open(outhtml, 'w') as f:

    # prepend file with a table header
    f.write(header)

    for row in c.execute('SELECT * FROM summary'):

        # unpack values form SQL record
        (id, date, model, dataset, kval, ktest, lr, momentum, decay, dropout, imgacc, imgloss, imgwratio, imgwmean, imgwstd, convlayers) = row
        convlayers = json.loads(convlayers)

        # generate table row
        tablerow = '<tr>'
        tablerow += '<td>' + str(id) + '</td>'
        tablerow += '<td>' + date + '</td>'
        tablerow += '<td>' + model + '</td>'
        tablerow += '<td>' + dataset + '</td>'
        tablerow += '<td>' + str(kval) + '</td>'
        tablerow += '<td>' + str(ktest) + '</td>'
        tablerow += '<td>' + str(lr) + '</td>'
        tablerow += '<td>' + str(momentum) + '</td>'
        tablerow += '<td>' + str(decay) + '</td>'
        tablerow += '<td>' + str(dropout) + '</td>'
        tablerow += '<td><a href="' + imgacc + '"><img src="' + imgacc + '" height="200" /></a></td>'
        tablerow += '<td><a href="' + imgloss + '"><img src="' + imgloss + '" height="200" /></a></td>'
        tablerow += '<td><a href="' + imgwratio + '"><img src="' + imgwratio + '" height="200" /></a></td>'
        tablerow += '<td><a href="' + imgwmean + '"><img src="' + imgwmean + '" height="200" /></a></td>'
        tablerow += '<td><a href="' + imgwstd + '"><img src="' + imgwstd + '" height="200" /></a></td>'
        for layer in convlayers:
            tablerow += '<td><a href="' + layer['img'] + '"><img src="' + layer['img'] + '" height="200" /></a></td>'
            tablerow += '<td>' + 'number: ' + layer['numout'] + '<br>' + \
                                 'size: ' + layer['size'] + '<br>' + \
                                 'stride: ' + layer['stride'] + '</td>'
        tablerow += '</tr>'

        f.write(tablerow)

    # append footer with CSS to the file
    f.write(footer)

# We can also close the connection if we are done with it.
# Just be sure any changes have been committed or they will be lost.
conn.close()