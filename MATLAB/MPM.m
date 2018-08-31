load depths
load train

isTrain = depths.IsTrain;
id = train.id;
test_id = depths.id(isTrain==0);

sortie = table('Size',[18000 2],'VariableTypes',{'cell','string'},'VariableNames',{'id','rle_mask'});
sortie.id = test_id;
sortie.Properties.RowNames = sortie.id;

cl1 = 0;
cl2 = 1;

X = [depths.z depths.Mean depths.Std depths.Entropy depths.Lap_mean depths.Lap_std depths.Hist];

nX = normalize(X);

[~,score,~,explained] = ACP(nX,0.95);
% [~,score,~,explained] = ACP(nX);

Xtrain = score(isTrain==1,:);
Xtest = score(isTrain==0,:);

Idx = knnsearch(Xtrain,Xtest,'K',10);

IdImages = arrayfun(@(x) train.id{x},Idx,'UniformOutput',false);

P00 = arrayfun(@(x) depths.p00(x),IdImages);
P11 = arrayfun(@(x) depths.p11(x),IdImages);

P0 = arrayfun(@(x) depths.p0(x),IdImages);

mP0 = mean(P0,2);

mP00 = mean(P00,2);
mP11 = mean(P11,2);

filenameTest = 'test/images/%s.png';

tmp = [];

for i=1:length(test_id)
    
    id = test_id(i);
    im = imread(sprintf(filenameTest,id{1}));
    chaine = double(Im2chaine(im(:,:,1)));
    
    [mSalt,sSalt,mNosalt,sNosalt] = estimate_gauss(IdImages(i,:));
    
    p00 = mP00(i);
    p11 = mP11(i);
    
    A = [p00 (1-p00) ; (1-p11) p11];
    
    n = length(chaine);
    
    Mat_f = gauss2(chaine,n,mNosalt,sNosalt,mSalt,sSalt);
    
    Z = MPM_chaines2(Mat_f,n,0,1,A,1-mP0(i),mP0(i));
    Zmask = double(chaine2im(Z'));
    RLE = Mask_to_RLE(Zmask);
    RLE_out = sprintf('% d',RLE');
    sRLE = string(RLE_out(1:end-1));
    
    tmp(i) = sRLE;
    
end

sortie.rle_mask = tmp;

writetable(sortie,'sortie.csv');