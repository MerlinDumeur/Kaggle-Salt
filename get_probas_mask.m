function A = get_probas_mask(mask)
%GET_PROBAS_MASK 
%   Detailed explanation goes here

cl1 = max(mask(:));

chaine = Im2chaine(mask);

n = length(chaine);
    
X0 = (mask == 0);
X1 = (mask == cl1);
    
X0b = X0(2:n);
X1b = X1(2:n);
    
X0a = X0(1:n-1);
X1a = X1(1:n-1);
    
X00 = X0a .* X0b;
X11 = X1a .* X1b;

if sum(X1(1:n-1)) == 0
    p11 = 0;
    
else
    p11 = sum(X11)/sum(X1(1:n-1));
    
end

if sum(X0(1:n-1)) == 0
    
    p00 = 0;
    
else
    p00 = sum(X00)/sum(X0(1:n-1));
    
end

    
A = [p00 p11];

end

