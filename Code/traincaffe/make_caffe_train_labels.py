def readTrainLabels(filePath, input_name):
    with open(filePath + input_name) as textFile:
        text = list()
        textFile.readline()
        for line in textFile:
            text.append('/storage/hpc_anna/Kaggle_DRD/input/size256/train/' + line.replace(',', '.JPEG '))
    return text

def writeTrainLabels(text, filePath, output_name):
    f = open(filePath+output_name, 'w')
    for sentence in text:
        f.write(sentence)


filePath = '/storage/hpc_anna/Kaggle_DRD/input/'
trainLabels = readTrainLabels(filePath, 'trainLabels.csv')
writeTrainLabels(trainLabels, filePath, 'trainCaffeLabels.csv')