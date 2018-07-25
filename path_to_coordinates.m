function coordinates = path_to_coordinates(path)
%PATH_TO_COORDINATES transform path matrix to coordinates array
%   

n = length(path(:));

coordinates = zeros(n,2);

for i = 0:n-1
    
    [pos1,pos2] = find(path==i,1,'last');
    coordinates(i+1,:) = [pos1 pos2];

end

