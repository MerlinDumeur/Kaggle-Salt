function [mSalt,sSalt,mNosalt,sNosalt] = estimate_gauss(images)

filenameTrain = 'train/images/%s.png';
filenameMask = 'train/masks/%s.png';

salt = [];
nosalt = [];

for i = 1:length(images)
   
    im = imread(sprintf(filenameTrain,images{i}));
    mask = imread(sprintf(filenameMask,images{i}));
    
    im2D = im(:,:,1);
    mask2D = mask(:,:,1);
    
    im_chaine = Im2chaine(im2D);
    mask_chaine = Im2chaine(mask2D);
    
    salt = [salt im_chaine(mask_chaine ~= 0)'];
    nosalt = [nosalt im_chaine(mask_chaine == 0)'];
    
end

if isempty(salt)
    
    mSalt = 255;
    sSalt = 0;
    
else

    mSalt = mean(salt');
%     disp(salt);
%     disp(class(salt));
%     disp(size(salt));
    sSalt = std(double(salt'));

end
    
if isempty(nosalt)
    
    mNosalt = 0;
    sNosalt = 0;
    
else
    
    mNosalt = mean(nosalt');
    sNosalt = std(double(nosalt'));

end


end