close all;

load depths
load train

load Stats\Z
load Stats\M
load Stats\S
load Stats\E
load Stats\H

load Stats\Lm.mat
load Stats\Ls.mat

H_ids = 1:hist_bins;
s = size(H_ids);
X = [Z('Array') M('Array') S('Array') E('Array') Lm('Array') Ls('Array') zeros(4000,s(2))];

for i=1:s(2)
    
    X(:,i+6) = H{H_ids(i)}('Array');
    
end

nX = normalize(X);

[Components,~,coeffs,explained] = ACP(nX);

disp(explained);
% disp(coeffs);

% [idx,Centers] = clustering(X);
idx = ones(4000,1);

load Stats\mlog
load Stats\lmlog.mat

load Stats\M_m.mat
load Stats\M_lm.mat

load Stats\P00.mat
load Stats\P11.mat

load Stats\logP00.mat
load Stats\logP11.mat

colour = M_m;  

tracer3(Components{1},Components{2},Components{3},colour,20,false,idx,'filled');
tracer3(Components{1},Components{3},Components{4},colour,20,false,idx,'filled');
tracer3(Components{2},Components{3},Components{4},colour,20,false,idx,'filled');
tracer(Components{1},Components{2},colour,20,false,'filled');



% tracer(Z,E,colour,20,true,'filled');

% tracer3(M,S,Z,colour,20,true,'filled');
% tracer(Z,M,colour,20,true,'filled');