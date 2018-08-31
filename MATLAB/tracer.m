function [fig] = tracer(X,Y,Colour,taille,save,options)
%TRACER Plots
%   

fig = figure('pos',[0 0 1920 1080]);

scatter(X('Array'),Y('Array'),taille,Colour('Array'),options);

xlabel(X('Description'));
ylabel(Y('Description'));

hcb = colorbar;
title(hcb,Colour('Description'));

F = "%s%s_%s";
filename = sprintf(F,X('Name'),Y('Name'),Colour('Name'));

if save
    
    Fpng = "CR/images/%s.png";
    Feps = "CR/images/%s.eps";
    saveas(fig,sprintf(Fpng,filename));
    saveas(fig,sprintf(Feps,filename));

end