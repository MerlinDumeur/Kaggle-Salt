function [X]=Im2chaine(image2D)

load peano_coord_cell.mat K

X = arrayfun(@(x) image2D(x{1}(1),x{1}(2)),K);

end