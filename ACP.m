function [Components,score,coeffs,explained] = ACP(X,n)
%ACP Summary of this function goes here
%   Detailed explanation goes here

s = size(X);
keyset = {'Array','Name','Description'};

if ~exist('n','var')
   
    n = s(2);
    
end

if n < 1
    
    [coeffs,score,~,~,explained] = pca(X,'NumComponents',s(2));
    
    i = 1;
    
    while sum(explained(1:i)) < n*100
        
       i = i+1;
        
    end
    
    n = i;
    score = score(:,1:i);
    
else

    [coeffs,score,~,~,explained] = pca(X,'NumComponents',n);

end

Components = cell(s(1),n);

description = "Principal component %d";
name = "ACP_%d";

for i=1:n
   
    Components{i} = containers.Map(keyset,{score(:,i),sprintf(name,i),sprintf(description,i)});
    
end

end

