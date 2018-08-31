P = peano_tautenhahn([101 101],0);
C = path_to_coordinates(P);

K = cell(10201,1);
for i=1:10201

    K{i} = C(i,:);

end

close all;
line(C(:,2),C(:,1));
pbaspect([1 1 1]);

save('peano_curve.mat','P');
save('peano_coordinates.mat','C');
save('peano_coord_cell.mat','K');