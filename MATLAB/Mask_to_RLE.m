function [RLE] = Mask_to_RLE(Mask)
%MASK_TO_RLE Fonction passant du masque � l'encodage RLE de celui-ci
%   

s = size(Mask);
fMask = reshape(Mask,[1,s(1)*s(2)]);
split_points = find(diff(fMask));

if mean(fMask(:)) == 1
    
   RLE = [1 ; length(fMask(:))];
    
elseif mean(fMask(:)) == 0
    
    RLE = [];
    
else

    RLE = zeros(length(split_points)+fMask(1)+fMask(end),1);

    disp(size(RLE));

    start_end = [1 length(RLE)];
    offset = 0;


    disp(size(split_points));
    disp(mean(fMask))

    if fMask(1) == 1
        RLE(1) = 1;
        RLE(2) = split_points(1);
        start_end(1)=2;
        offset = 1;
    end

    if fMask(end) == 1
        RLE(end) = (s(1)*s(2))-split_points(end);
        RLE(end-1) = split_points(end)+1;
        start_end(2) = start_end(2)-2;
    end    



    for i = start_end(1):2:start_end(2)-offset

    %     disp(i+offset)
    %     disp(RLE)

        RLE(i+offset) = split_points(i)+1;
        RLE(i+offset+1) = split_points(i+1)-split_points(i);

    end
end
if length(RLE) < 2
    
    RLE = [];
    
end

