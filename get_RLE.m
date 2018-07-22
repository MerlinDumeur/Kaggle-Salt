function [RLE] = get_RLE(id,table)
%GET_RLE Return vector form of RLE corresponding to a given ID
%   

if ~exist('table','var')
    % third parameter does not exist, so default it to something
    table = readtable('train.csv','ReadVariableNames',true);
    table.Properties.RowNames = table.id;
end

RLE = table.rle_mask(id);
RLE = split(RLE,' ');

if length(RLE) < 2

    RLE = [];

else
    
    RLE = cellfun(@str2num,RLE);

end

