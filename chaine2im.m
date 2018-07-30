function image = chaine2im(chaine)
%CHAINE2IM Converts a markov chain output into an image
%   

load peano_coord_cell.mat K

s = size(chaine);
n = sqrt(s(1));
disp(n);
image = zeros(n,'uint8');

for i=1:s(1)
    
    c = K{i};
    image(c(1),c(2)) = chaine(i);

end