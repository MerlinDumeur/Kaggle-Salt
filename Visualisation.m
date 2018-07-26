close all;

load_data;

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

colour = mlog;  

tracer3(Components{1},Components{2},Components{3},colour,20,false,idx,'filled');
tracer3(Components{1},Components{3},Components{4},colour,20,false,idx,'filled');
tracer3(Components{2},Components{3},Components{4},colour,20,false,idx,'filled');
tracer(Components{1},Components{2},colour,20,false,'filled');



% tracer(Z,E,colour,20,true,'filled');

% tracer3(M,S,Z,colour,20,true,'filled');
% tracer(Z,M,colour,20,true,'filled');