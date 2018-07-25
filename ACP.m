function [Components,coeffs,explained] = ACP(X,n)
%ACP Summary of this function goes here
%   Detailed explanation goes here

s = size(X);
keyset = {'Array','Name','Description'};

if ~exist('n','var')
   
    n = s(2);
    
end

[coeffs,score,~,~,explained] = pca(X,'NumComponents',n);

Components = cell(s(1),n);

description = "Principal component %d";
name = "ACP_%d";

for i=1:n
   
    Components{i} = containers.Map(keyset,{score(:,i),sprintf(name,i),sprintf(description,i)});
    
end

end

