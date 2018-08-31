function A = get_probas(mask,cl0,cl1)
%GET_PROBAS Get transition probas from mask
%   
    n = length(mask);
    
    X0 = (mask == cl0);
    X1 = (mask == cl1);
    
    X0b = X0(2:n);
    X1b = X1(2:n);
    
    X0a = X0(1:n-1);
    X1a = X1(1:n-1);
    
    X00 = X0a .* X0b;
    X11 = X1a .* X1b;
    
    p00 = sum(X00)/sum(X0(1:n-1));
    p11 = sum(X11)/sum(X1(1:n-1));
    
    A = [p00 (1-p00)
        (1-p11) p11];

end