trainDir = "train/images3";
maskDir = 'train/masks3';
testDir = "test/images3";

trainDS = imageDatastore(trainDir);

classNames = ["Nosalt" "Salt"];
pixelLabelID = [0 1];

pxDS = pixelLabelDatastore(maskDir,classNames,pixelLabelID);

% augmentedTrainDS = augmentedImageDatastore([128 128],trainDS);
trainingData = pixelLabelImageDatastore(trainDS,pxDS);
trainingData = shuffle(trainingData);
validationData = partitionByIndex(trainingData,1:500);
trainingData = partitionByIndex(trainingData,501:4000);

opts = trainingOptions('adam',...
    'InitialLearnRate',5e-3, ...
    'L2Regularization',0.05, ...
    'LearnRateSchedule','piecewise',...
    'MaxEpochs',50,...
    'Shuffle','once',...
    'MiniBatchSize',8,...
    'ValidationData',validationData,...
    'Plots','training-progress');



testDS = imageDatastore(testDir);

inputSize = [128 128];

imageLayer = imageInputLayer(inputSize,'Normalization','none','Name','im_input');

finalLayers = [
    convolution2dLayer(3,64,'Padding',1,'Name','conv_17');
    reluLayer('Name','relu_17')
    convolution2dLayer(3,64,'Padding',1,'Name','conv_18');
    reluLayer('Name','relu_18')
    convolution2dLayer(1,2,'Name','conv_1x1');
    softmaxLayer('Name','softmax')
    pixelClassificationLayer('Name','pxClassification')
    ];

layers = [
    imageLayer
    downsamplingLayer(32,1)
    downsamplingLayer(64,2)
    downsamplingLayer(128,3)
    downsamplingLayer(256,4)
    upsamplingLayer(512,5)
    upsamplingLayer(256,6)
    upsamplingLayer(128,7)
    upsamplingLayer(64,8)
    finalLayers
    ];

%     depthConcatenationLayer(2,'Name','concat_1')

% disp(layers);

lgraph = layerGraph(layers);
lgraph = connectLayers(lgraph,'relu_2/out','concat_5/in2');
lgraph = connectLayers(lgraph,'relu_4/out','concat_4/in2');
lgraph = connectLayers(lgraph,'relu_6/out','concat_3/in2');
lgraph = connectLayers(lgraph,'relu_8/out','concat_2/in2');

% feat = imageInputLayer([7 7 1],'Normalization','none');
% lgraph = addLayers(lgraph,feat);
% lgraph = connectLayers(lgraph,'feat/out','concat_1/in2');

net = trainNetwork(trainingData,lgraph,opts);
res = semanticseg(testDS,net,"WriteLocation","res");