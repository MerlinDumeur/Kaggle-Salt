load data

cl1 = 0;
cl2 = 1;

nX = normalize(X);

[~,~,coeffs,~] = ACP(nX);

% nX*coeffs' = scores

