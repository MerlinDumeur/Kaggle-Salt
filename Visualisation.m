close all;

load Stats\Z
load Stats\M
load Stats\S
load Stats\E

load Stats\Lm.mat
load Stats\Ls.mat

X = [Z('Array') M('Array') S('Array') E('Array') Lm('Array') Ls('Array')];

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
tracer(C{1},C{2},colour,20,false,'filled');
tracer(Z,E,colour,20,true,'filled');
tracer(M,E,colour,20,true,'filled');
tracer(Lm,E,colour,20,true,'filled');
tracer(Ls,E,colour,20,true,'filled');

% tracer3(M,S,Z,colour,20,true,'filled');
% tracer(Z,M,colour,20,true,'filled');