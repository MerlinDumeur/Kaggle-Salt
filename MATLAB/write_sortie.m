load MAP_MPM\depths
load MAP_MPM\train

threshold = 0.05;

isTrain = depths.IsTrain;
id = train.id;
test_id = depths.id(isTrain==0);
sorted = sort(test_id);

sortie = table('Size',[18000 2],'VariableTypes',{'cell','string'},'VariableNames',{'id','rle_mask'});
sortie.id = test_id;
sortie.Properties.RowNames = sortie.id;

filenameSeg = 'res/pixelLabel_%s.png';

tmp = cell(18000,1);

parfor i = 1:length(test_id)
   
    id = sorted(i);
    
    z = zeros(1,4-floor(log10(i)));
    n = [z i];
    s = sprintf('%d',n);
    
    mask = imread(sprintf(filenameSeg,s)) - 1;
    
    mask_resized = imresize(mask,0.785,'nearest');
    
    if mean(mask_resized(:))<threshold
       
        mask_resized = zeros(101);
        
    end
    
    RLE = Mask_to_RLE(double(mask_resized));
    RLE_out = sprintf('% d',RLE');
    sRLE = string(RLE_out(2:end));
    
    tmp{i} = sRLE;
    
end

sortie.rle_mask = tmp;

writetable(sortie,'sortie.csv');