% depths = readtable('depths.csv','ReadVariableNames',true);
% depths.Properties.RowNames = depths.id;

% train = readtable('train.csv','ReadVariableNames',true);
% train.Properties.RowNames = train.id;

load depths
load train

n = length(depths.id);

% depths.IsTrain = zeros(n,1);
% depths.IsTrain(train.id)=1;

% global hist_bins;
% hist_bins = 20;
% depths.Hist = zeros(22000,hist_bins);

filenameTrain = 'train/images/%s.png';
filenameTest = 'test/images/%s.png';
filenameMask = 'train/masks/%s.png';

% lap = [-1 -1 -1 ; -1 8 -1 ; -1 -1 -1];

depths.p00 = zeros(22000,1);
depths.p11 = zeros(22000,1);

% 
% for i = 1:length(depths.id)
%     
%     if depths.IsTrain(i)
%         im = imread(sprintf(filenameTrain,depths.id{i}));
%     else
%         im = imread(sprintf(filenameTest,depths.id{i}));
%     end
    
%     im2D = im(:,:,1);
%     imD = im2double(im2D);

%     counts = imhist(im2D,hist_bins);
    
%     depths.Hist(i,:) = counts;

%     depths.Entropy(i) = entropy(im2D);
    
%     resp = imfilter(imD,lap,'conv');
%     depths.Lap_std(i) = std2(resp);
%     depths.Lap_mean(i) = mean2(resp);
    
%     depths.Std(i) = std2(im);
%     depths.Mean(i) = mean2(im);
    
% end

for i = 1:length(train.id)
    
    id = train.id{i};
% 
    mask = imread(sprintf(filenameMask,id));
% 
% 
    mask2D = mask(:,:,1);
    
    A = get_probas_mask(mask2D);
    
    depths.p00(id) = A(1);
    depths.p11(id) = A(2);
    
%     maskD = im2double(mask2D);
%     
%     resp = imfilter(maskD,lap,'conv');
%     
%     
%     depths.Mask_lmean(train.id{i}) = mean2(resp);
%     depths.Mask_lstd(train.id{i}) = std2(resp);
    
%     depths.Mask_mean(train.id{i}) = mean2(mask);
%     depths.Mask_std(train.id{i}) = std2(mask);
    
end

save('depths.mat','depths');
save('train.mat','train');