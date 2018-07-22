depths = readtable('depths.csv','ReadVariableNames',true);
depths.Properties.RowNames = depths.id;

train = readtable('train.csv','ReadVariableNames',true);

n = length(depths.id);

depths.IsTrain = zeros(n,1);
depths.IsTrain(train.id)=1;

stats = zeros(n,1);

filenameTrain = 'train/images/%s.png';
filenameTest = 'test/images/%s.png';

%for i = 1:10
for i = 1:length(depths.id)
    
    if depths.IsTrain(i)==1
        im = imread(sprintf(filenameTrain,depths.id{i}));
    else
        im = imread(sprintf(filenameTest,depths.id{i}));
    end
    
    im2D = im(:,:,1);
    depths.Std(i) = std2(im);
    depths.Mean(i) = mean2(im);
    depths.Corr(i) = corr2(im2D,im2D);
    
end

save('depths.mat','depths');