close all;

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

[C,coeffs,explained] = ACP(nX);

disp(explained);
disp(coeffs);

load Stats\mlog
load Stats\lmlog.mat
load Stats\M_m.mat
load Stats\M_lm.mat

colour = mlog;

tracer3(C{1},C{2},C{3},colour,20,false,'filled');
tracer3(C{1},C{3},C{4},colour,20,false,'filled');
tracer3(C{2},C{3},C{4},colour,20,false,'filled');
tracer(C{1},C{2},colour,20,false,'filled');


% tracer(Z,E,colour,20,true,'filled');

% tracer3(M,S,Z,colour,20,true,'filled');
% tracer(Z,M,colour,20,true,'filled');