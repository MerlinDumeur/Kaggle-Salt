load depths
load train

isTrain = depths.IsTrain;
id = train.id;
test_id = depths.id(isTrain==0);

filenameTrain = 'train/images/%s.png';
filenameTrain2 = 'train/images2/%s.png';
filenameTrain3 = 'train/images3/%s.png';

filenameMask = 'train/masks/%s.png';
filenameMask2 = 'train/masks2/%s.png';
filenameMask3 = 'train/masks3/%s.png';

filenameTest = 'test/images/%s.png';
filenameTest2 = 'test/images2/%s.png';
filenameTest3 = 'test/images3/%s.png';

filenameSeg = 'res/pixelLabel_%s.png';
filenameSeg2 = 'res/%s.png';

for i = 1:length(test_id)
   
    id = test_id(i);
    
%     im = imread(sprintf(filenameTest,id{1}));
%     im_out = im(:,:,1);
%     
%     imwrite(im_out,sprintf(filenameTest2,id{1}));

    im = imread(sprintf(filenameTest2,id{1}));
    im_out = imresize(im,1.26);
    
    imwrite(im_out,sprintf(filenameTest3,id{1}));
    
end

sorted = sort(test_id);

% for i = 1:length(test_id)
%     
%     id = sorted(i);
%     
%     z = zeros(1,4-floor(log10(i)));
%     
%     n = [z i];
%     
%     s = sprintf('%d',n);
%     
%     im = imread(sprintf(filenameSeg,s));
%     
%     imwrite(im,sprintf(filenameSeg2,id{1}));
%     
% end

for i = 1:length(train.id)
    
    id = train.id{i};

%     im = imread(sprintf(filenameTrain,id));
%     im_out = im(:,:,1);
%     
%     imwrite(im_out,sprintf(filenameTrain2,id));
    
%     mask = imread(sprintf(filenameMask,id));
%     mask_out = uint8(mask > 0);
%     imwrite(mask_out,sprintf(filenameMask2,id));

    
    im = imread(sprintf(filenameTrain2,id));
    im_out = imresize(im,1.26);
    
    imwrite(im_out,sprintf(filenameTrain3,id));
    
    mask = imread(sprintf(filenameMask2,id));
    mask_out = imresize(im,1.26,'nearest');
    imwrite(mask_out,sprintf(filenameMask3,id));

    
end