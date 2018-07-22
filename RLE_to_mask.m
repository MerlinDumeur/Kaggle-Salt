function [mask] = RLE_to_mask(RLE,height,width)
%RLE_TO_MASK Fonction pour passer d'un encodage RLE à la matrice du masque
%   

n = length(RLE)/2;

mask = zeros(width,height);
RLE = reshape(RLE,[2,n]);

for i=1:n
    
    mask(RLE(1,i):RLE(1,i)+RLE(2,i)-1) = 1;

end