close all;

load Stats\Z
load Stats\M
load Stats\S

load Stats\Lm.mat
load Stats\Ls.mat

X = [Z('Array') M('Array') S('Array') Lm('Array') Ls('Array')];

nX = normalize(X);

[C,explained] = ACP(nX);

disp(explained);

load Stats\mlog
load Stats\lmlog.mat
load Stats\M_m.mat
load Stats\M_lm.mat

colour = M_m;

tracer3(C{1},C{2},C{3},colour,20,false,'filled');
tracer(C{1},C{2},colour,20,false,'filled');

% tracer3(M,S,Z,colour,20,true,'filled');
% tracer(Z,M,colour,20,true,'filled');