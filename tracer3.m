function fig = tracer3(X,Y,Z,Colour,taille,save,options)
%TRACER3 Plots 3D scatterplot
%   

fig = figure('pos',[0 0 1920 1080]);

scatter3(X('Array'),Y('Array'),Z('Array'),taille,Colour('Array'),options);

xlabel(X('Description'));
ylabel(Y('Description'));
zlabel(Z('Description'));

hcb = colorbar;
title(hcb,Colour('Description'))

F = "%s%s%s_%s";
filename = sprintf(F,X('Name'),Y('Name'),Z('Name'),Colour('Name'));

if save
    
    Fpng = "CR/images/%s.png";
    Feps = "CR/images/%s.eps";
    saveas(fig,sprintf(Fpng,filename));
    saveas(fig,sprintf(Feps,filename));

end

