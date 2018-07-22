depths = readtable('depths.csv','ReadVariableNames',true);
depths.Properties.RowNames = depths.id;
train = readtable('train.csv','ReadVariableNames',true);
train.Properties.RowNames = train.id;

id = '4875705fb0';
filenameF = 'train/images/%s.png';
im = imread(sprintf(filenameF,id));
s = size(im);



%RLE = get_RLE(id,train);
%m = RLE_to_mask(RLE,s(1),s(2));
%R = Mask_to_RLE(m);