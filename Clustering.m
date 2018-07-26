function [best_idx,best_C] = clustering(X)

n_replicates = 5;
KList = 5:10;


eva = evalclusters(X,'kmeans','silhouette','KList',KList);
bestK = eva.OptimalK;

[best_idx,best_C] = kmeans(X,bestK,'Replicates',n_replicates);

% for k = n_clusters(2:end)
% 
%     [idx,C] = kmeans(X,k,'Replicates',n_replicates);
% 
%     if dist < best_dist
%        
%         best_idx = idx;
%         best_C = C;
%         best_dist = dist;
%         
%     end
%     
end