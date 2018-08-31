function l = downsamplingLayer(numFilters,id)
%DOWNSAMPLINGLA Summary of this function goes here
%   Detailed explanation goes here

% if nargin < 2
%     
%     filterSize = 3;
%    
% end
%     
% if nargin < 3
% 
%     Padding = 1;
%     
% end

name_conv = 'conv_%d';
name_relu = 'relu_%d';
name_mpool = 'max-pool_%d';

conv1 = convolution2dLayer(3,numFilters,'Padding',1,'Name',sprintf(name_conv,(id-1)*2+1)); 
relu1 = reluLayer('Name',sprintf(name_relu,(id-1)*2+1));
conv2 = convolution2dLayer(3,numFilters,'Padding',1,'Name',sprintf(name_conv,(id-1)*2+2));
relu2 = reluLayer('Name',sprintf(name_relu,(id-1)*2+2));
mpool = maxPooling2dLayer(2,'Stride',2,'Padding','same','Name',sprintf(name_mpool,id));

l = [
    conv1
    relu1
    conv2
    relu2
    mpool
    ];

% l = [
%     convolution2dLayer(filterSize,numFilters,'Padding',Padding,'Name',sprintf(name_conv,(id-1)*2+1))
%     reluLayer('Name',sprintf(name_relu,(id-1)*2+1))
%     convolution2dLayer(filterSize,numFilters,'Padding',Padding,'Name',sprintf(name_conv,(id-1)*2+2))
%     reluLayer('Name',sprintf(name_relu,(id-1)*2+1))
%     maxPooling2dLayer(poolSize,'Stride',2,'Padding','same','Name',sprintf(name_mpool,id))
%     ];

end

