depths = readtable('depths.csv','ReadVariableNames',true);
depths.Properties.RowNames = depths.id;

train = readtable('train.csv','ReadVariableNames',true);
train.Properties.RowNames = train.id;

n = length(depths.id);

depths.IsTrain = zeros(n,1);
depths.IsTrain(train.id)=1;

filenameTrain = 'train/images/%s.png';
filenameTest = 'test/images/%s.png';
filenameMask = 'train/masks/%s.png';


for i = 1:length(depths.id)
    
    if depths.IsTrain(i)==1
        im = imread(sprintf(filenameTrain,depths.id{i}));
    else
        im = imread(sprintf(filenameTest,depths.id{i}));
    end
    
    im2D = im(:,:,1);
    depths.Std(i) = std2(im);
    depths.Mean(i) = mean2(im);
    
end

for i = 1:length(train.id)
    
    mask = imread(sprintf(filenameMask,train.id{i}));
    
    depths.Mask_mean(train.id{i}) = mean2(mask);
    depths.Mask_std(train.id{i}) = std2(mask);
    
end

save('depths.mat','depths');
save('train.mat','train');