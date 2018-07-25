P = peano_tautenhahn([501 501],0);
C = path_to_coordinates(P);

close all;
line(C(:,2),C(:,1));
pbaspect([1 1 1]);