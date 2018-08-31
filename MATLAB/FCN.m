% i = 2;
% I = readimage(trainDS,i);
% C = readimage(pxDS,i);
% B = labeloverlay(I,C);
% imshow(B)

inputSize = [101 101];
filterSize = 3;
numFilters = 64;
poolSize = 2;

imgLayer = imageInputLayer(inputSize);
conv = convolution2dLayer(filterSize,numFilters,'Padding',1);
relu = reluLayer();
maxPoolDownsample2x = maxPooling2dLayer(poolSize,'Stride',2,'Padding','same');

downsamplingLayers = [
    conv
    relu
    maxPoolDownsample2x
    conv
    relu
    maxPoolDownsample2x
    ];

filterSize_upsample = 3;
transposedConvUpsample2x = transposedConv2dLayer(filterSize_upsample,numFilters,'Stride',2,'Cropping',1);

upsamplingLayers = [
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    ];

numClasses = 2;
conv1x1 = convolution2dLayer(1,numClasses);

finalLayers = [
    conv1x1
    softmaxLayer()
    pixelClassificationLayer('ClassNames',classNames)
    ];

net1 = [
    imgLayer
    downsamplingLayers
    upsamplingLayers
    finalLayers
    ];

numFilters = 16;
filterSize = 3;
numClasses = 2;

layers = [
    imageInputLayer([101 101 1])
    convolution2dLayer(filterSize,numFilters,'Padding',1)
    reluLayer()
    maxPooling2dLayer(2,'Stride',2,'Padding','same')
    convolution2dLayer(filterSize,numFilters,'Padding',1)
    reluLayer()
    transposedConv2dLayer(3,numFilters,'Stride',2,'Cropping',1);
    convolution2dLayer(1,numClasses);
    softmaxLayer()
    pixelClassificationLayer()
    ];

trainDir = "train/images2";
maskDir = 'train/masks2';
testDir = "test/images";

trainDS = imageDatastore(trainDir);

classNames = ["Nosalt" "Salt"];
pixelLabelID = [0 1];

pxDS = pixelLabelDatastore(maskDir,classNames,pixelLabelID);

opts = trainingOptions('adam',...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.001, ...
    'LearnRateSchedule','piecewise',...
    'MaxEpochs',100,...
    'Shuffle','every-epoch',...
    'MiniBatchSize',16,...
    'Plots','training-progress');

trainingData = pixelLabelImageDatastore(trainDS,pxDS);
testDS = imageDatastore("test/images2");


numFilters = 6;

layers2 = [
imageInputLayer(inputSize)
convolution2dLayer(filterSize,numFilters,'Stride',2,'Padding',1)
reluLayer
transposedConv2dLayer(3,1,'Stride',2,'Cropping',1)
convolution2dLayer(1,numClasses)
softmaxLayer
pixelClassificationLayer('ClassNames',classNames)
];

net = trainNetwork(trainingData,net1,opts);
res = semanticseg(testDS,net,"WriteLocation","res");

