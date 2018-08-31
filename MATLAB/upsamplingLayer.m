function [l] = upsamplingLayer(numFilters,id)
%UPSAMPLINGLAYER Summary of this function goes here
%   Detailed explanation goes here


% if nargin < 2
%     
%     filterSize = 3;
%    
% end
%     
% if nargin < 3
% 
%     padding = 1;
%     
% end

numFilters_upsample = floor(numFilters/2);

name_conv = 'conv_%d';
name_relu = 'relu_%d';
name_concat = 'concat_%d';
name_tconv = 'tr-conv_%d';

if true
   
    filterSize_upsample = 2;
    cropping_upsample = 0;
    
else
    
    filterSize_upsample = 3;
    cropping_upsample = 1;
    
end

l = [
    convolution2dLayer(3,numFilters,'Padding',1,'Name',sprintf(name_conv,(id-1)*2+1))
    reluLayer('Name',sprintf(name_relu,(id-1)*2+1));
    convolution2dLayer(3,numFilters,'Padding',1,'Name',sprintf(name_conv,(id-1)*2+2))
    reluLayer('Name',sprintf(name_relu,(id-1)*2+2));
    transposedConv2dLayer(filterSize_upsample,numFilters_upsample,'Stride',2,'Cropping',cropping_upsample,'Name',sprintf(name_tconv,id-4));
    depthConcatenationLayer(2,'Name',sprintf(name_concat,(id-4)+1))
    ];


end

